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
            let eventClusters = EventClusterFactory(
                events: events,
                timelineStartDate: options.timelineStartDate,
                maximumEventsPerCluster: options.maximumEventsPerEntry
            ).makeClusters()
            
            let entries = eventClusters.map(makeTimelineEntry(cluster:))
            
            completionHandler(entries)
        }
    }
    
    private func makeTimelineEntry(cluster: EventCluster) -> EventTimelineEntry {
        let viewModels = cluster.events.map(EventViewModel.init)
        let entry = EventTimelineEntry(
            date: cluster.clusterStartTime,
            events: viewModels,
            additionalEventsCount: cluster.additionalEventCount
        )
        
        return entry
    }
    
    private struct EventClusterFactory {
        
        var events: [Event]
        var timelineStartDate: Date
        var maximumEventsPerCluster: Int
        
        func makeClusters() -> [EventCluster] {
            let distinctStartTimes = resolveClusteringDates()
            let eventClusters = distinctStartTimes.map(makeEventCluster(startTime:))
            return eventClusters
        }
        
        private func resolveClusteringDates() -> [Date] {
            let eligibleClusterDates = events.map(\.startTime).filter({ $0 >= timelineStartDate })
            let distinctClusterDates = Set(eligibleClusterDates)
            return distinctClusterDates.sorted()
        }
        
        private func makeEventCluster(startTime: Date) -> EventCluster {
            let eventsOnOrAfterTime = events.filter({ $0.startTime >= startTime }).sorted(by: \.title)
            let eventsToTake = min(maximumEventsPerCluster, eventsOnOrAfterTime.count)
            let clusterEvents = Array(eventsOnOrAfterTime[0..<eventsToTake])
            let remainingEvents = eventsOnOrAfterTime.count - eventsToTake
            
            let cluster = EventCluster(
                clusterStartTime: startTime,
                events: clusterEvents,
                additionalEventCount: remainingEvents
            )
            
            return cluster
        }
        
    }
    
    private struct EventCluster {
        
        var clusterStartTime: Date
        var events: [Event]
        var additionalEventCount: Int
        
    }
    
}
