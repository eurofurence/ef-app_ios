import Foundation.NSDate

struct ResolveTimelineEntriesTask {
    
    var repository: EventRepository
    var maximumEventsPerEntry: Int
    var timelineStartDate: Date
    var completionHandler: ([EventTimelineEntry]) -> Void
    
    func resolveEntries() {
        repository.loadEvents(completionHandler: clusterEventsIntoEntries(_:))
    }
    
    private func clusterEventsIntoEntries(_ events: [Event]) {
        let eventClusters = EventClusterFactory(
            events: events,
            timelineStartDate: timelineStartDate,
            maximumEventsPerCluster: maximumEventsPerEntry
        ).makeClusters()
        
        let entries = eventClusters.map(EventTimelineEntry.init(cluster:))
        
        completionHandler(entries)
    }
    
}
