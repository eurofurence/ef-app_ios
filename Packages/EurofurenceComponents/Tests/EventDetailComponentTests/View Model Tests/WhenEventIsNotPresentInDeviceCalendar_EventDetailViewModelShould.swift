import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenEventIsNotPresentInDeviceCalendar_EventDetailViewModelShould: XCTestCase {
    
    func testIncludeAddToCalendarAction() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier))
        calendarEvent.simulateEventAbsent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, "Add to Calendar")
    }
    
    func testAddEventToCalendarWhenInvokingAction() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier))
        calendarEvent.simulateEventAbsent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        command?.perform(sender: "Sender")
        
        XCTAssertEqual(.added, calendarEvent.lastAction)
        XCTAssertEqual("Sender", calendarEvent.lastActionSender as? String)
    }
    
    func testShowTheRemoveFromCalendarActionAfterAddingEventToCalendar() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier))
        calendarEvent.simulateEventAbsent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        command?.perform()
        
        XCTAssertEqual(actionVisitor.actionTitle, "Remove from Calendar")
    }
    
}
