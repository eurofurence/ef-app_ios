@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventThatIsNotFavourite_EventDetailInteractorShould: XCTestCase {

    func testTellTheDelegateItIsUnfavourited() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)

        XCTAssertTrue(delegate.toldEventUnfavourited)
    }

    func testNotTellTheDelegateItIsFavourited() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)

        XCTAssertFalse(delegate.toldEventFavourited)
    }
    
    func testIncludeFavouriteActionAfterSummary() {
        let event = FakeEvent.random
        event.unfavourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, String.favourite)
    }
    
    func testSwapToUnfavouriteEventActionWhenInvokingFavouriteEvent() {
        let event = FakeEvent.random
        event.unfavourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        
        let command = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        command?.perform()
        
        XCTAssertEqual(actionVisitor.actionTitle, String.unfavourite)
    }

}
