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
    ) -> EventCluster {
        let eligibleEvents = filteringPolicy.filterEvents(events, inGroupStartingAt: startTime)
        let eventsOnOrAfterTime = eligibleEvents.filter({ $0.startTime >= startTime }).sorted(by: \.title)
        let eventsToTake = min(maximumEventsPerCluster, eventsOnOrAfterTime.count)
        let clusterEvents = Array(eventsOnOrAfterTime[0..<eventsToTake])
        let remainingEvents = eventsOnOrAfterTime.count - eventsToTake
        
        let lastEventTimeInCluster = clusterEvents.map(\.endTime).max() ?? Date()
        
        return EventCluster(
            clusterStartTime: startTime,
            lastEventTimeInCluster: lastEventTimeInCluster,
            events: clusterEvents,
            additionalEventCount: remainingEvents
        )
    }
    
}
