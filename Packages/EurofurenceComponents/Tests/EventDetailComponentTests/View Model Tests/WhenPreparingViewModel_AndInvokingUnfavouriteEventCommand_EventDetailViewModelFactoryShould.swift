import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_AndInvokingUnfavouriteEventCommand_EventDetailViewModelFactoryShould: XCTestCase {

    func testUpdateTheCommandTitleToFavouriteTheEvent() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        command?.perform()
        
        XCTAssertEqual(actionVisitor.actionTitle, String.favourite)
    }
    
    func testFavouriteTheEventWhenCommandTurnsIntoUnfavouritingCommand() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        command?.perform()
        command?.perform()
        
        XCTAssertEqual(event.favouritedState, .favourited)
        XCTAssertEqual(actionVisitor.actionTitle, String.unfavourite)
    }

}
