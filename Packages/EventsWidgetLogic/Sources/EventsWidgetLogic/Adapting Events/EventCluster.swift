import Foundation.NSDate

struct EventCluster {
    
    var clusterStartTime: Date
    var lastEventTimeInCluster: Date
    var events: [Event]
    var additionalEventCount: Int
    
    static func clusterEvents(
        _ events: [Event],
        startingAt startTime: Date,
        filteringPolicy: TimelineEntryFilteringPolicy,
        maximumEventsPerCluster: Int
    ) -> EventCluster? {
        let clusterStartTime = filteringPolicy.proposedEntryStartTime(forEventsClustereredAt: startTime)
        let eligibleEvents = filteringPolicy.filterEvents(events, inGroupStartingAt: clusterStartTime)
        
        if eligibleEvents.isEmpty {
            return nil
        }
        
        let eventsOnOrAfterTime = eligibleEvents.filter({ $0.startTime >= startTime }).sorted(by: \.title)
        let eventsToTake = min(maximumEventsPerCluster, eventsOnOrAfterTime.count)
        let clusterEvents = Array(eventsOnOrAfterTime[0..<eventsToTake])
        let remainingEvents = eventsOnOrAfterTime.count - eventsToTake
        
        let lastEventTimeInCluster = clusterEvents.map(\.endTime).max() ?? Date()
        
        return EventCluster(
            clusterStartTime: clusterStartTime,
            lastEventTimeInCluster: lastEventTimeInCluster,
            events: clusterEvents,
            additionalEventCount: remainingEvents
        )
    }
    
}
