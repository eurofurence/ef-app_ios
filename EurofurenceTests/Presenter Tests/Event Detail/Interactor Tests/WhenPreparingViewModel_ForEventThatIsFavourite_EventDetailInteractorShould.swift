@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventThatIsFavourite_EventDetailInteractorShould: XCTestCase {

    func testTellTheDelegateItIsAFavourite() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)

        XCTAssertTrue(delegate.toldEventFavourited)
    }

    func testNotTellTheDelegateItIsUnfavourited() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)

        XCTAssertFalse(delegate.toldEventUnfavourited)
    }
    
    func testIncludeUnfavouriteActionAfterSummary() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, String.unfavourite)
    }
    
    func testUnfavouriteTheEventWhenInvokingUnfavouriteAction() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        command?.perform()
        
        XCTAssertEqual(event.favouritedState, .unfavourited)
    }

}
