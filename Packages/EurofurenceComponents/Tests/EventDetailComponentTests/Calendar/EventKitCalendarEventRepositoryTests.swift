import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class FakeEventStore: EventStore {
    
    var registeredEventDefinitions = Set<EventStoreEventDefinition>() {
        didSet {
            simulateStoreDidChange()
        }
    }
    
    weak var delegate: EventStoreDelegate?
    
    private(set) var addedEventDefinition: EventStoreEventDefinition?
    private(set) var editingSender: Any?
    func editEvent(definition event: EventStoreEventDefinition, sender: Any?) {
        addedEventDefinition = event
        editingSender = sender
        registeredEventDefinitions.insert(addedEventDefinition.unsafelyUnwrapped)
    }
    
    private(set) var removedEventIdentifier: EventStoreEventDefinition?
    func removeEvent(identifiedBy identifier: EventStoreEventDefinition) {
        registeredEventDefinitions.remove(identifier)
    }
    
    func contains(eventDefinition: EventStoreEventDefinition) -> Bool {
        registeredEventDefinitions.contains(eventDefinition)
    }
    
    func simulateStoreDidChange() {
        delegate?.eventStoreChanged(self)
    }
    
}

class EventKitCalendarEventRepositoryTests: XCTestCase {
    
    func testAddingEntryForEventSuppliesEventInformation() throws {
        let scheduleRepository = FakeScheduleRepository()
        let event = FakeEvent.random
        scheduleRepository.allEvents = [event]
        
        let eventStore = FakeEventStore()
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: event.identifier)
        let sender = self
        calendarEntry?.addToCalendar(sender)
        
        let expected = expectedEventDefinition(for: event)
        
        XCTAssertEqual(expected, eventStore.addedEventDefinition)
        XCTAssertIdentical(self, eventStore.editingSender as? XCTestCase)
    }
    
    func testRemovingEntryForEventByIdentifier() throws {
        let scheduleRepository = FakeScheduleRepository()
        let event = FakeEvent.random
        scheduleRepository.allEvents = [event]
        
        let eventStore = FakeEventStore()
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: event.identifier)
        calendarEntry?.addToCalendar(self)
        calendarEntry?.removeFromCalendar()
        
        let unexpected = expectedEventDefinition(for: event)
        
        XCTAssertFalse(eventStore.registeredEventDefinitions.contains(unexpected))
    }
    
    func testAttemptingToAddEntryForUnknownEventDoesNothing() throws {
        let scheduleRepository = FakeScheduleRepository()
        let eventStore = FakeEventStore()
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: .random)
        calendarEntry?.addToCalendar(nil)
        
        XCTAssertNil(eventStore.addedEventDefinition)
    }
    
    func testEventExistsInCalendar_WhenDelegateAttached() {
        let scheduleRepository = FakeScheduleRepository()
        let event = FakeEvent.random
        scheduleRepository.allEvents = [event]
        
        let eventStore = FakeEventStore()
        let eventDefinition = expectedEventDefinition(for: event)
        
        eventStore.registeredEventDefinitions.insert(eventDefinition)
        
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: event.identifier)
        let delegate = CapturingCalendarEventDelegate()
        calendarEntry?.delegate = delegate
        
        XCTAssertEqual(.present, delegate.eventPresence)
    }
    
    func testEventDoesNotExistInCalendar_WhenDelegateAttached() {
        let scheduleRepository = FakeScheduleRepository()
        let event = FakeEvent.random
        scheduleRepository.allEvents = [event]
        
        let eventStore = FakeEventStore()
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: event.identifier)
        let delegate = CapturingCalendarEventDelegate()
        calendarEntry?.delegate = delegate
        
        XCTAssertEqual(.absent, delegate.eventPresence)
    }
    
    func testEventExistsInCalendar_WhenDelegateAttached_ThenRemoved() {
        let scheduleRepository = FakeScheduleRepository()
        let event = FakeEvent.random
        scheduleRepository.allEvents = [event]
        
        let eventStore = FakeEventStore()
        eventStore.registeredEventDefinitions.insert(expectedEventDefinition(for: event))
        
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: event.identifier)
        let delegate = CapturingCalendarEventDelegate()
        calendarEntry?.delegate = delegate
        calendarEntry?.removeFromCalendar()
        
        XCTAssertEqual(.absent, delegate.eventPresence)
    }
    
    func testEventDoesNotExistInCalendar_WhenDelegateAttached_ThenAdded() {
        let scheduleRepository = FakeScheduleRepository()
        let event = FakeEvent.random
        scheduleRepository.allEvents = [event]
        
        let eventStore = FakeEventStore()
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: event.identifier)
        let delegate = CapturingCalendarEventDelegate()
        calendarEntry?.delegate = delegate
        calendarEntry?.addToCalendar(nil)
        
        XCTAssertEqual(.present, delegate.eventPresence)
    }
    
    func testEventExistsInCalendar_ThenRemovedFromStoreOutsideOfApplication() {
        let scheduleRepository = FakeScheduleRepository()
        let event = FakeEvent.random
        scheduleRepository.allEvents = [event]
        
        let eventStore = FakeEventStore()
        eventStore.registeredEventDefinitions.insert(expectedEventDefinition(for: event))
        
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: event.identifier)
        let delegate = CapturingCalendarEventDelegate()
        calendarEntry?.delegate = delegate
        eventStore.registeredEventDefinitions.remove(expectedEventDefinition(for: event))
        eventStore.simulateStoreDidChange()
        
        XCTAssertEqual(.absent, delegate.eventPresence)
    }
    
    private func expectedEventDefinition(for event: Event) -> EventStoreEventDefinition {
        EventStoreEventDefinition(
            identifier: event.identifier.rawValue,
            title: event.title,
            room: event.room.name,
            startDate: event.startDate,
            endDate: event.endDate,
            deeplinkURL: event.contentURL,
            shortDescription: event.abstract
        )
    }
    
    private class CapturingCalendarEventDelegate: CalendarEventDelegate {
        
        private(set) var eventPresence: CalendarEventPresence?
        func calendarEvent(_ calendarEvent: CalendarEvent, presenceDidChange eventPresence: CalendarEventPresence) {
            self.eventPresence = eventPresence
        }
        
    }

}
