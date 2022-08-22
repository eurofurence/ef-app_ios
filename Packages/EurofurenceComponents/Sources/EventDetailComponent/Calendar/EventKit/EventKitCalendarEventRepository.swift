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
        
        private let eventDefinition: EventStoreEventDefinition
        private let eventStore: EventStore
        
        private var lastKnownEventPresence: CalendarEventPresence {
            didSet {
                delegate?.calendarEvent(self, presenceDidChange: lastKnownEventPresence)
            }
        }
        
        init(event: Event, eventStore: EventStore) {
            self.eventStore = eventStore
            
            self.eventDefinition = EventStoreEventDefinition(
                identifier: event.identifier.rawValue,
                title: event.title,
                room: event.room.name,
                startDate: event.startDate,
                endDate: event.endDate,
                deeplinkURL: event.contentURL,
                shortDescription: event.abstract
            )
            
            lastKnownEventPresence = eventStore.contains(eventDefinition: eventDefinition) ? .present : .absent
        }
        
        var delegate: CalendarEventDelegate? {
            didSet {
                delegate?.calendarEvent(self, presenceDidChange: lastKnownEventPresence)
            }
        }
        
        func addToCalendar(_ sender: Any?) {
            eventStore.editEvent(definition: eventDefinition, sender: sender) { [weak self] (success) in
                self?.lastKnownEventPresence = success ? .present : .absent
            }
            
            delegate?.calendarEvent(self, presenceDidChange: .present)
        }
        
        func removeFromCalendar() {
            eventStore.removeEvent(identifiedBy: eventDefinition)
            lastKnownEventPresence = .absent
        }
        
    }
    
}
