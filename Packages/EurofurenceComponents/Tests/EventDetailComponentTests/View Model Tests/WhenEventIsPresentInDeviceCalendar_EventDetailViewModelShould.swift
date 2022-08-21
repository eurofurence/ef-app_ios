import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class FakeCalendarEventRepository: CalendarEventRepository {
    
    private var events = [String: FakeCalendarEvent]()
    
    func calendarEvent(for identifier: String) -> CalendarEvent {
        if let event = events[identifier] {
            return event
        } else {
            let event = FakeCalendarEvent()
            events[identifier] = event
            
            return event
        }
    }
    
    func fakedEvent(for identifier: String) -> FakeCalendarEvent? {
        events[identifier]
    }
    
}

class FakeCalendarEvent: CalendarEvent {
    
    enum CalendarAction: Equatable {
        case unset
        case added
        case removed
    }
    
    weak var delegate: CalendarEventDelegate?
    
    private(set) var lastAction: CalendarAction = .unset
    func addToCalendar() {
        lastAction = .added
        delegate?.calendarEvent(self, presenceDidChange: .present)
    }
    
    func removeFromCalendar() {
        lastAction = .removed
        delegate?.calendarEvent(self, presenceDidChange: .absent)
    }
    
    func simulateEventPresent() {
        delegate?.calendarEvent(self, presenceDidChange: .present)
    }
    
    func simulateEventAbsent() {
        delegate?.calendarEvent(self, presenceDidChange: .absent)
    }
    
}

class WhenEventIsPresentInDeviceCalendar_EventDetailViewModelShould: XCTestCase {
    
    func testIncludeRemoveFromCalendarAction() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier.rawValue))
        calendarEvent.simulateEventPresent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, "Remove from Calendar")
    }
    
    func testRemoveEventFromCalendarWhenInvokingAction() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier.rawValue))
        calendarEvent.simulateEventPresent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        command?.perform()
        
        XCTAssertEqual(.removed, calendarEvent.lastAction)
    }
    
    func testShowTheAddToCalendarActionAfterRemovingEventFromCalendar() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier.rawValue))
        calendarEvent.simulateEventPresent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        command?.perform()
        
        XCTAssertEqual(actionVisitor.actionTitle, "Add to Calendar")
    }

}
