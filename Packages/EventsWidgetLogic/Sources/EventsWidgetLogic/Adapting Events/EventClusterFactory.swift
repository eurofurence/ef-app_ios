import Foundation.NSDate

struct EventClusterFactory {
    
    var events: [Event]
    var filteringPolicy: TimelineEntryFilteringPolicy
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
        EventCluster.clusterEvents(
            events,
            startingAt: startTime,
            filteringPolicy: filteringPolicy,
            maximumEventsPerCluster: maximumEventsPerCluster
        )
    }
    
}
