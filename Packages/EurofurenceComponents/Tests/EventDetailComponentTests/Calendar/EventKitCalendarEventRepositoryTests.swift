import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class FakeEventStore: EventStore {
    
    private(set) var addedEventDefinition: EventStoreEventDefinition?
    private(set) var editingSender: Any?
    func editEvent(definition event: EventStoreEventDefinition, sender: Any?) {
        addedEventDefinition = event
        editingSender = sender
    }
    
    private(set) var removedEventIdentifier: String?
    func removeEvent(identifiedBy identifier: String) {
        removedEventIdentifier = identifier
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
        
        let expected = EventStoreEventDefinition(
            identifier: event.identifier.rawValue,
            title: event.title,
            startDate: event.startDate,
            endDate: event.endDate,
            deeplinkURL: event.contentURL
        )
        
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
        calendarEntry.removeFromCalendar()
        
        XCTAssertEqual(event.identifier.rawValue, eventStore.removedEventIdentifier)
    }
    
    func testAttemptingToAddEntryForUnknownEventDoesNothing() throws {
        let scheduleRepository = FakeScheduleRepository()
        let eventStore = FakeEventStore()
        let calendarEventRepository = EventKitCalendarEventRepository(
            eventStore: eventStore,
            scheduleRepository: scheduleRepository
        )
        
        let calendarEntry = calendarEventRepository.calendarEvent(for: .random)
        calendarEntry.removeFromCalendar()
        
        XCTAssertNil(eventStore.addedEventDefinition)
        XCTAssertNil(eventStore.removedEventIdentifier)
    }

}
