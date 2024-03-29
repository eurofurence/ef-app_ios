import Foundation.NSDate

struct ResolveTimelineEntriesTask {
    
    var repository: EventRepository
    var filteringPolicy: TimelineEntryFilteringPolicy
    var eventCategory: EventCategory
    var isFavouritesOnly: Bool
    var maximumEventsPerEntry: Int
    var timelineStartDate: Date
    var viewModelFactory: EventViewModelFactory
    var completionHandler: (EventsTimeline) -> Void
    
    private var accessibleFormatString: String {
        switch (eventCategory, isFavouritesOnly) {
        case (.upcoming, false):
            return NSLocalizedString(
                "%li upcoming events",
                bundle: .module,
                comment: "Format string to designate the number of upcoming events"
            )
            
        case (.upcoming, true):
            return NSLocalizedString(
                "%li upcoming favourite events",
                bundle: .module,
                comment: "Format string to designate the number of upcoming favourite events"
            )
            
        case (.running, false):
            return NSLocalizedString(
                "%li running events",
                bundle: .module,
                comment: "Format string to designate the number of running events"
            )
            
        case (.running, true):
            return NSLocalizedString(
                "%li running favourite events",
                bundle: .module,
                comment: "Format string to designate the number of running favourite events"
            )
        }
    }
    
    private func makeAccessibleDescription(numberOfEvents: Int) -> String {
        String.localizedStringWithFormat(accessibleFormatString, numberOfEvents)
    }
    
    func resolveEntries() {
        repository.loadEvents(completionHandler: clusterEventsIntoEntries(_:))
    }
    
    private func clusterEventsIntoEntries(_ events: [Event]) {
        let eventClusters = EventClusterFactory(
            events: events,
            filteringPolicy: filteringPolicy,
            timelineStartDate: timelineStartDate,
            maximumEventsPerCluster: maximumEventsPerEntry
        ).makeClusters()
        
        let timeline = makeTimeline(from: eventClusters)
        completionHandler(timeline)
    }
    
    private func makeTimeline(from clusters: [EventCluster]) -> EventsTimeline {
        if let first = clusters.first {
            return makeEventsTimeline(firstCluster: first, allClusters: clusters)
        } else {
            return makeEmptyTimeline()
        }
    }
    
    private func makeEventsTimeline(firstCluster: EventCluster, allClusters: [EventCluster]) -> EventsTimeline {
        let snapshotEntry: EventTimelineEntry
        let remainingEntries: [EventTimelineEntry]
        
        if firstCluster.clusterStartTime > timelineStartDate {
            snapshotEntry = EventTimelineEntry(
                date: timelineStartDate,
                accessibleSummary: makeAccessibleDescription(numberOfEvents: 0),
                content: .empty,
                context: .init(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
            )
            
            remainingEntries = allClusters.map(makeTimelineEntry(from:))
        } else {
            snapshotEntry = makeTimelineEntry(from: firstCluster)
            remainingEntries = allClusters.suffix(from: 1).map(makeTimelineEntry(from:))
        }
        
        var timelineEntries = [EventTimelineEntry]()
        timelineEntries.append(snapshotEntry)
        timelineEntries.append(contentsOf: remainingEntries)
        
        let lastCluster = allClusters.last ?? firstCluster
        
        let endOfSchedule = EventTimelineEntry(
            date: lastCluster.lastEventTimeInCluster,
            accessibleSummary: makeAccessibleDescription(numberOfEvents: 0),
            content: .empty,
            context: .init(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
        )
        
        timelineEntries.append(endOfSchedule)
        
        let timeline = EventsTimeline(snapshot: snapshotEntry, entries: timelineEntries)
        return timeline
    }
    
    private func makeEmptyTimeline() -> EventsTimeline {
        let snapshotEntry = EventTimelineEntry(
            date: timelineStartDate,
            accessibleSummary: makeAccessibleDescription(numberOfEvents: 0),
            content: .empty,
            context: EventTimelineEntry.Context(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
        )
        
        return EventsTimeline(snapshot: snapshotEntry, entries: [snapshotEntry])
    }
    
    private func makeTimelineEntry(from cluster: EventCluster) -> EventTimelineEntry {
        let viewModels = cluster.events.map(viewModelFactory.makeViewModel(for:))
        return EventTimelineEntry(
            date: cluster.clusterStartTime,
            accessibleSummary: makeAccessibleDescription(numberOfEvents: viewModels.count),
            content: .events(viewModels: viewModels),
            context: EventTimelineEntry.Context(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
        )
    }
    
}
