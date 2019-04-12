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
        context.viewModel?.setDelegate(delegate)

        XCTAssertTrue(delegate.toldEventUnfavourited)
    }

    func testNotTellTheDelegateItIsFavourited() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)

        XCTAssertFalse(delegate.toldEventFavourited)
    }

}
