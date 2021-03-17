import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForEventThatIsFavourite_EventDetailViewModelFactoryShould: XCTestCase {

    func testTellTheDelegateItIsAFavourite() {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        event.favourite()

        XCTAssertTrue(delegate.toldEventFavourited)
    }

    func testNotTellTheDelegateItIsUnfavourited() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)

        XCTAssertFalse(delegate.toldEventUnfavourited)
    }
    
    func testIncludeUnfavouriteActionAfterSummary() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, String.unfavourite)
    }
    
    func testUnfavouriteTheEventWhenInvokingUnfavouriteAction() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        command?.perform()
        
        XCTAssertEqual(event.favouritedState, .unfavourited)
    }

}
