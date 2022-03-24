import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenServiceIndicatesEventIsFavourited_EventDetailViewModelFactoryShould: XCTestCase {

    func testTellTheViewModelDelegateTheEventIsFavourited() {
        let event = FakeEvent.random
        event.unfavourite()
        let service = FakeScheduleRepository(favourites: [])
        let context = EventDetailViewModelFactoryTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        let visitor = context.prepareVisitorForTesting()
        let toggleFavouriteCommand = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        toggleFavouriteCommand?.perform()

        XCTAssertTrue(delegate.toldEventFavourited)
    }

    func testNotTellTheViewModelDelegateTheEventIsFavouritedWhenNotInFavouriteIdentifiers() {
        let event = FakeEvent.random
        let service = FakeScheduleRepository(favourites: [])
        let context = EventDetailViewModelFactoryTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        context.eventsService.simulateEventFavourited(identifier: .random)

        XCTAssertFalse(delegate.toldEventFavourited)
    }

}
