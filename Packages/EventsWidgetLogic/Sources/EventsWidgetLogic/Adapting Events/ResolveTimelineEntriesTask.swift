import Foundation.NSDate

struct ResolveTimelineEntriesTask {
    
    var repository: EventRepository
    var eventCategory: EventCategory
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
            timelineStartDate: timelineStartDate,
            maximumEventsPerCluster: maximumEventsPerEntry
        ).makeClusters()
        
        let timeline = makeTimeline(from: eventClusters)
        completionHandler(timeline)
    }
    
    private func makeTimeline(from clusters: [EventCluster]) -> EventsTimeline {
        let snapshotEntry: EventTimelineEntry
        let timelineEntries: [EventTimelineEntry]
        if let first = clusters.first {
            snapshotEntry = makeTimelineEntry(from: first)
            let remainingEntries = clusters.suffix(from: 1).map(makeTimelineEntry(from:))
            timelineEntries = [snapshotEntry] + remainingEntries
        } else {
            snapshotEntry = EventTimelineEntry(
                date: timelineStartDate,
                events: [],
                additionalEventsCount: 0,
                context: EventTimelineEntry.Context(category: eventCategory)
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
            events: viewModels,
            additionalEventsCount: cluster.additionalEventCount,
            context: EventTimelineEntry.Context(category: eventCategory)
        )
    }
    
}
