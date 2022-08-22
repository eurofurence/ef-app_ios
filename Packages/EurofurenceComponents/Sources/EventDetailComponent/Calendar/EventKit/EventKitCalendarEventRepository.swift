import EurofurenceModel

public class EventKitCalendarEventRepository: CalendarEventRepository, EventStoreDelegate {
    
    private let eventStore: EventStore
    private let schedule: Schedule
    private var calendarEvents = WeakCollection<EventKitCalendarEvent>()
    
    public init(eventStore: EventStore, scheduleRepository: ScheduleRepository) {
        self.schedule = scheduleRepository.loadSchedule(tag: "EventKitCalendarEventRepository")
        self.eventStore = eventStore
        eventStore.delegate = self
    }
    
    public func eventStoreChanged(_ eventStore: EventStore) {
        calendarEvents.forEach { event in
            event.updatePresence()
        }
    }
    
    public func calendarEvent(for identifier: EventIdentifier) -> CalendarEvent? {
        guard let event = schedule.loadEvent(identifier: identifier) else { return nil }
        
        let calendarEvent = EventKitCalendarEvent(event: event, eventStore: eventStore)
        calendarEvents.add(calendarEvent)
        
        return calendarEvent
    }
    
    private class EventKitCalendarEvent: CalendarEvent {
        
        private let eventDefinition: EventStoreEventDefinition
        private let eventStore: EventStore
        
        private var lastKnownEventPresence: CalendarEventPresence = .absent {
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
            
            updatePresence()
        }
        
        var delegate: CalendarEventDelegate? {
            didSet {
                delegate?.calendarEvent(self, presenceDidChange: lastKnownEventPresence)
            }
        }
        
        func addToCalendar(_ sender: Any?) {
            eventStore.editEvent(definition: eventDefinition, sender: sender)
        }
        
        func removeFromCalendar() {
            eventStore.removeEvent(identifiedBy: eventDefinition)
        }
        
        fileprivate func updatePresence() {
            lastKnownEventPresence = eventStore.contains(eventDefinition: eventDefinition) ? .present : .absent
        }
        
    }
    
}
