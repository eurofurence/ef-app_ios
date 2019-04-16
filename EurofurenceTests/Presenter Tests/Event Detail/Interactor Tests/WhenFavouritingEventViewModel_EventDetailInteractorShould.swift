@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFavouritingEventViewModel_EventDetailInteractorShould: XCTestCase {

    func testTellTheEventToBeFavourited() {
        let event = FakeEvent.random
        let context = EventDetailInteractorTestBuilder().build(for: event)
        context.viewModel.favourite()

        XCTAssertEqual(event.favouritedState, .favourited)
    }

}
