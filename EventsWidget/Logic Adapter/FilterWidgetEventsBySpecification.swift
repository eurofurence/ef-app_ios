import EurofurenceModel
import EventsWidgetLogic
import Foundation.NSDate

struct FilterWidgetEventsBySpecification: TimelineEntryFilteringPolicy {
    
    let bridge: EventsBridge
    let clock: ControllableClock
    let specification: AnySpecification<EurofurenceModel.Event>
    
    func filterEvents(
        _ events: [EventsWidgetLogic.Event],
        inGroupStartingAt startTime: Date
    ) -> [EventsWidgetLogic.Event] {
        clock.currentDate = startTime
        
        let eventIdentifiers = events.map(\.id)
        let modelEvents = bridge.allEvents.filter({ eventIdentifiers.contains($0.identifier.rawValue) })
        let filteredModelEventIdentifiers = modelEvents.filter(specification.isSatisfied(by:)).map(\.identifier.rawValue)
        let filteredEvents = events.filter({ filteredModelEventIdentifiers.contains($0.id) })
        
        return filteredEvents
    }
    
    func proposedEntryStartTime(forEventsClustereredAt clusterTime: Date) -> Date {
        clusterTime
    }
    
}
