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
        let snapshotEntry: EventTimelineEntry
        var timelineEntries = [EventTimelineEntry]()
        
        if let first = clusters.first {
            let remainingEntries: [EventTimelineEntry]
            if first.clusterStartTime > timelineStartDate {
                snapshotEntry = EventTimelineEntry(
                    date: timelineStartDate,
                    content: .empty,
                    context: .init(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
                )
                
                remainingEntries = clusters.map(makeTimelineEntry(from:))
            } else {
                snapshotEntry = makeTimelineEntry(from: first)
                remainingEntries = clusters.suffix(from: 1).map(makeTimelineEntry(from:))
            }
            
            timelineEntries.append(snapshotEntry)
            timelineEntries.append(contentsOf: remainingEntries)
            
            let lastCluster = clusters.last ?? first
            
            let endOfSchedule = EventTimelineEntry(
                date: lastCluster.lastEventTimeInCluster,
                content: .empty,
                context: .init(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
            )
            
            timelineEntries.append(endOfSchedule)
        } else {
            snapshotEntry = EventTimelineEntry(
                date: timelineStartDate,
                content: .empty,
                context: EventTimelineEntry.Context(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
            )
            
            timelineEntries = [snapshotEntry]
        }
        
        let timeline = EventsTimeline(snapshot: snapshotEntry, entries: timelineEntries)
        return timeline
    }
    
    private func makeTimelineEntry(from cluster: EventCluster) -> EventTimelineEntry {
        let viewModels = cluster.events.map(viewModelFactory.makeViewModel(for:))
        return EventTimelineEntry(
            date: cluster.clusterStartTime,
            content: .events(viewModels: viewModels, additionalEventsCount: cluster.additionalEventCount),
            context: EventTimelineEntry.Context(category: eventCategory, isFavouritesOnly: isFavouritesOnly)
        )
    }
    
}
