@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenServiceIndicatesEventIsUnfavourited_EventDetailInteractorShould: XCTestCase {

    func testTellTheViewModelDelegateTheEventIsUnfavourited() {
        let event = FakeEvent.random
        let service = FakeEventsService(favourites: [event.identifier])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(delegate)
        context.viewModel.unfavourite()

        XCTAssertTrue(delegate.toldEventUnfavourited)
    }

}
