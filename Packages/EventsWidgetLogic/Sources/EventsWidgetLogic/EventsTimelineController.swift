import Foundation

public struct EventsTimelineController {
    
    private let repository: EventRepository
    
    public init(context: EventWidgetContext, repository: EventRepository) {
        self.repository = repository
    }
    
    public func makeEntries(completionHandler: @escaping ([EventTimelineEntry]) -> Void) {
        repository.loadEvents { (events) in
            let eventClusters = clusterEventsByStartTime(events)
            let entries = eventClusters.map(makeTimelineEntry(cluster:))
            
            completionHandler(entries)
        }
    }
    
    private func clusterEventsByStartTime(_ events: [Event]) -> [EventCluster] {
        let distinctStartTimes = Set(events.map(\.startTime)).sorted()
        
        var eventClusters = [EventCluster]()
        for startTime in distinctStartTimes {
            let eventsOnOrAfterTime = events.filter({ $0.startTime >= startTime })
            let cluster = EventCluster(clusterStartTime: startTime, events: eventsOnOrAfterTime)
            eventClusters.append(cluster)
        }
        
        return eventClusters
    }
    
    private func makeTimelineEntry(cluster: EventCluster) -> EventTimelineEntry {
        let viewModels = cluster.events.map(EventViewModel.init)
        let entry = EventTimelineEntry(date: cluster.clusterStartTime, events: viewModels, additionalEventsCount: 0)
        
        return entry
    }
    
    private struct EventCluster {
        
        var clusterStartTime: Date
        var events: [Event]
        
    }
    
}
