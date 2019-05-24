@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_AndInvokingUnfavouriteEventCommand_EventDetailInteractorShould: XCTestCase {

    func testUpdateTheCommandTitleToFavouriteTheEvent() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
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
        let context = EventDetailInteractorTestBuilder().build(for: event)
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
