import Foundation

public struct EventsTimelineController {
    
    private let repository: EventRepository
    private let options: Options
    
    public struct Options {
        
        let maximumEventsPerEntry: Int
        let timelineStartDate: Date
        
        public init(maximumEventsPerEntry: Int, timelineStartDate: Date) {
            self.maximumEventsPerEntry = maximumEventsPerEntry
            self.timelineStartDate = timelineStartDate
        }
        
    }
    
    public init(repository: EventRepository, options: Options) {
        self.repository = repository
        self.options = options
    }
    
    public func makeEntries(completionHandler: @escaping ([EventTimelineEntry]) -> Void) {
        repository.loadEvents { (events) in
            let eventClusters = clusterEventsByStartTime(events)
            let entries = eventClusters.map(makeTimelineEntry(cluster:))
            
            completionHandler(entries)
        }
    }
    
    private func clusterEventsByStartTime(_ events: [Event]) -> [EventCluster] {
        let distinctStartTimes = Set(events.map(\.startTime)).sorted().filter({ $0 >= options.timelineStartDate })
        
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
