@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenServiceIndicatesEventIsFavourited_EventDetailInteractorShould: XCTestCase {

    func testTellTheViewModelDelegateTheEventIsFavourited() {
        let event = FakeEvent.random
        event.unfavourite()
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        let toggleFavouriteCommand = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        toggleFavouriteCommand?.perform()

        XCTAssertTrue(delegate.toldEventFavourited)
    }

    func testNotTellTheViewModelDelegateTheEventIsFavouritedWhenNotInFavouriteIdentifiers() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        context.eventsService.simulateEventFavourited(identifier: .random)

        XCTAssertFalse(delegate.toldEventFavourited)
    }

}
