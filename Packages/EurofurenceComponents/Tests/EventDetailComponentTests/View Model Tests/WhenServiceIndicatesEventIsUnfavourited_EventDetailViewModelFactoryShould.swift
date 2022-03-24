import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenServiceIndicatesEventIsUnfavourited_EventDetailViewModelFactoryShould: XCTestCase {

    func testTellTheViewModelDelegateTheEventIsUnfavourited() {
        let event = FakeEvent.random
        event.favourite()
        let service = FakeScheduleRepository(favourites: [event.identifier])
        let context = EventDetailViewModelFactoryTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        let visitor = context.prepareVisitorForTesting()
        let toggleFavouriteCommand = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        toggleFavouriteCommand?.perform()

        XCTAssertTrue(delegate.toldEventUnfavourited)
    }

}
