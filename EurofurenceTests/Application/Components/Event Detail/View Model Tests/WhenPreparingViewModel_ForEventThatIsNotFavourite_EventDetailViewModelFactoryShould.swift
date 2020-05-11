import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventThatIsNotFavourite_EventDetailViewModelFactoryShould: XCTestCase {

    func testTellTheDelegateItIsUnfavourited() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailViewModelFactoryTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        event.unfavourite()

        XCTAssertTrue(delegate.toldEventUnfavourited)
    }

    func testNotTellTheDelegateItIsFavourited() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailViewModelFactoryTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)

        XCTAssertFalse(delegate.toldEventFavourited)
    }
    
    func testIncludeFavouriteActionAfterSummary() {
        let event = FakeEvent.random
        event.unfavourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, String.favourite)
    }
    
    func testSwapToUnfavouriteEventActionWhenInvokingFavouriteEvent() {
        let event = FakeEvent.random
        event.unfavourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        command?.perform()
        
        XCTAssertEqual(actionVisitor.actionTitle, String.unfavourite)
    }

}
