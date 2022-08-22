import EurofurenceModel

public struct EventKitCalendarEventRepository: CalendarEventRepository {
    
    private let eventStore: EventStore
    private let schedule: Schedule
    
    public init(eventStore: EventStore, scheduleRepository: ScheduleRepository) {
        self.schedule = scheduleRepository.loadSchedule(tag: "EventKitCalendarEventRepository")
        self.eventStore = eventStore
    }
    
    public func calendarEvent(for identifier: EventIdentifier) -> CalendarEvent {
        if let event = schedule.loadEvent(identifier: identifier) {
            return EventKitCalendarEvent(event: event, eventStore: eventStore)
        } else {
            return NotACalendarEvent()
        }
    }
    
    private class NotACalendarEvent: CalendarEvent {
        
        var delegate: CalendarEventDelegate?
        
        func addToCalendar(_ sender: Any?) {
            
        }
        
        func removeFromCalendar() {
            
        }
        
    }
    
    private class EventKitCalendarEvent: CalendarEvent {
        
        private let event: Event
        private let eventStore: EventStore
        
        init(event: Event, eventStore: EventStore) {
            self.event = event
            self.eventStore = eventStore
        }
        
        var delegate: CalendarEventDelegate?
        
        func addToCalendar(_ sender: Any?) {
            let eventDefinition = EventStoreEventDefinition(
                identifier: event.identifier.rawValue,
                title: event.title,
                startDate: event.startDate,
                endDate: event.endDate,
                deeplinkURL: event.contentURL
            )
            
            eventStore.editEvent(definition: eventDefinition, sender: sender)
        }
        
        func removeFromCalendar() {
            eventStore.removeEvent(identifiedBy: event.identifier.rawValue)
        }
        
    }
    
}
