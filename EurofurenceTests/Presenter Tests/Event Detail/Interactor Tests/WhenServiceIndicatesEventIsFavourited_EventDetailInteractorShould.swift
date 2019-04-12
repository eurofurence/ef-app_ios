@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenServiceIndicatesEventIsFavourited_EventDetailInteractorShould: XCTestCase {

    func testTellTheViewModelDelegateTheEventIsFavourited() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.favourite()

        XCTAssertTrue(delegate.toldEventFavourited)
    }

    func testNotTellTheViewModelDelegateTheEventIsFavouritedWhenNotInFavouriteIdentifiers() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.eventsService.simulateEventFavourited(identifier: .random)

        XCTAssertFalse(delegate.toldEventFavourited)
    }

}
