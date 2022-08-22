import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class FakeEventStore: EventStore {
    
    var registeredEventDefinitions = Set<EventStoreEventDefinition>()
    
    private(set) var addedEventDefinition: EventStoreEventDefinition?
    private(set) var editingSender: Any?
    private var editCompletionHandler: ((Bool) -> Void)?
    func editEvent(
        definition event: EventStoreEventDefinition,
        sender: Any?,
        completionHandler: @escaping (Bool) -> Void
    ) {
        addedEventDefinition = event
        editingSender = sender
        editCompletionHandler = completionHandler
    }
    
    private(set) var removedEventIdentifier: EventStoreEventDefinition?
    func removeEvent(identifiedBy identifier: EventStoreEventDefinition) {
        registeredEventDefinitions.remove(identifier)
    }
    
    func contains(eventDefinition: EventStoreEventDefinition) -> Bool {
        registeredEventDefinitions.contains(eventDefinition)
    }
    
    func concludeCurrentEdit(success: Bool) {
        registeredEventDefinitions.insert(addedEventDefinition.unsafelyUnwrapped)
        editCompletionHandler?(success)
        addedEventDefinition = nil
        editCompletionHandler = nil
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
        calendarEntry.addToCalendar(sender)
        
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
        calendarEntry.addToCalendar(self)
        eventStore.concludeCurrentEdit(success: true)
        calendarEntry.removeFromCalendar()
        
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
        calendarEntry.addToCalendar(nil)
        
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
        calendarEntry.delegate = delegate
        
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
        calendarEntry.delegate = delegate
        
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
        calendarEntry.delegate = delegate
        calendarEntry.removeFromCalendar()
        
        XCTAssertEqual(.absent, delegate.eventPresence)
    }
    
    func testEventDoesNotExistInCalendar_WhenDelegateAttached_ThenAdded_Successfully() {
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
        calendarEntry.delegate = delegate
        calendarEntry.addToCalendar(nil)
        eventStore.concludeCurrentEdit(success: true)
        
        XCTAssertEqual(.present, delegate.eventPresence)
    }
    
    func testEventDoesNotExistInCalendar_WhenDelegateAttached_ThenAdded_Unsuccessfully() {
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
        calendarEntry.delegate = delegate
        calendarEntry.addToCalendar(nil)
        eventStore.concludeCurrentEdit(success: false)
        
        XCTAssertEqual(.absent, delegate.eventPresence)
    }
    
    private func expectedEventDefinition(for event: Event) -> EventStoreEventDefinition {
        EventStoreEventDefinition(
            identifier: event.identifier.rawValue,
            title: event.title,
            startDate: event.startDate,
            endDate: event.endDate,
            deeplinkURL: event.contentURL
        )
    }
    
    private class CapturingCalendarEventDelegate: CalendarEventDelegate {
        
        private(set) var eventPresence: CalendarEventPresence?
        func calendarEvent(_ calendarEvent: CalendarEvent, presenceDidChange eventPresence: CalendarEventPresence) {
            self.eventPresence = eventPresence
        }
        
    }

}
