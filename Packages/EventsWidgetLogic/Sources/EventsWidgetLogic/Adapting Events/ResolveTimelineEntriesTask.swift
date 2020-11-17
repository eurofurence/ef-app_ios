import Foundation.NSDate

struct ResolveTimelineEntriesTask {
    
    var repository: EventRepository
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
        
        let entries = eventClusters.map(makeTimelineEntry(from:))
        let timeline = EventsTimeline(entries: entries)
        
        completionHandler(timeline)
    }
    
    private func makeTimelineEntry(from cluster: EventCluster) -> EventTimelineEntry {
        let viewModels = cluster.events.map(viewModelFactory.makeViewModel(for:))
        return EventTimelineEntry(
            date: cluster.clusterStartTime,
            events: viewModels,
            additionalEventsCount: cluster.additionalEventCount
        )
    }
    
}
