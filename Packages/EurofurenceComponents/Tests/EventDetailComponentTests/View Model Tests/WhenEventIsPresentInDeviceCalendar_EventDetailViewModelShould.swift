import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenEventIsPresentInDeviceCalendar_EventDetailViewModelShould: XCTestCase {
    
    func testIncludeRemoveFromCalendarAction() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier))
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
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier))
        calendarEvent.simulateEventPresent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        command?.perform()
        
        XCTAssertEqual(.removed, calendarEvent.lastAction)
    }
    
    func testShowTheAddToCalendarActionAfterRemovingEventFromCalendar() throws {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let calendarEvent = try XCTUnwrap(context.calendarEventRepository.fakedEvent(for: event.identifier))
        calendarEvent.simulateEventPresent()
        let visitor = context.prepareVisitorForTesting()
        let command = visitor.visited(ofKind: AddEventToCalendarAction.self)
        
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        command?.perform()
        
        XCTAssertEqual(actionVisitor.actionTitle, "Add to Calendar")
    }

}
