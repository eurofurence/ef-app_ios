import Foundation.NSDate

struct EventClusterFactory {
    
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
