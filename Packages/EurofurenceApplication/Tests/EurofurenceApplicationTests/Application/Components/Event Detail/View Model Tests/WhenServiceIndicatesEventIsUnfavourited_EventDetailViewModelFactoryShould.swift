import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenServiceIndicatesEventIsUnfavourited_EventDetailViewModelFactoryShould: XCTestCase {

    func testTellTheViewModelDelegateTheEventIsUnfavourited() {
        let event = FakeEvent.random
        event.favourite()
        let service = FakeEventsService(favourites: [event.identifier])
        let context = EventDetailViewModelFactoryTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        let visitor = context.prepareVisitorForTesting()
        let toggleFavouriteCommand = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        toggleFavouriteCommand?.perform()

        XCTAssertTrue(delegate.toldEventUnfavourited)
    }

}
