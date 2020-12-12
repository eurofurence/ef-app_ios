import Foundation.NSDate

struct EventCluster {
    
    var clusterStartTime: Date
    var events: [Event]
    var additionalEventCount: Int
    
    static func clusterEvents(
        _ events: [Event],
        startingAt startTime: Date,
        filteringPolicy: TimelineEntryFilteringPolicy,
        maximumEventsPerCluster: Int
    ) -> EventCluster {
        let eligbleEvents = filteringPolicy.filterEvents(events, inGroupStartingAt: startTime)
        let eventsOnOrAfterTime = eligbleEvents.filter({ $0.startTime >= startTime }).sorted(by: \.title)
        let eventsToTake = min(maximumEventsPerCluster, eventsOnOrAfterTime.count)
        let clusterEvents = Array(eventsOnOrAfterTime[0..<eventsToTake])
        let remainingEvents = eventsOnOrAfterTime.count - eventsToTake
        
        return EventCluster(
            clusterStartTime: startTime,
            events: clusterEvents,
            additionalEventCount: remainingEvents
        )
    }
    
}
