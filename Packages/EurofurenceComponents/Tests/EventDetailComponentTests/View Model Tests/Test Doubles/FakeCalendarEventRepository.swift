import EurofurenceModel
import EventDetailComponent

class FakeCalendarEventRepository: CalendarEventRepository {
    
    private var events = [EventIdentifier: FakeCalendarEvent]()
    
    func calendarEvent(for identifier: EventIdentifier) -> CalendarEvent {
        if let event = events[identifier] {
            return event
        } else {
            let event = FakeCalendarEvent()
            events[identifier] = event
            
            return event
        }
    }
    
    func fakedEvent(for identifier: EventIdentifier) -> FakeCalendarEvent? {
        events[identifier]
    }
    
}
