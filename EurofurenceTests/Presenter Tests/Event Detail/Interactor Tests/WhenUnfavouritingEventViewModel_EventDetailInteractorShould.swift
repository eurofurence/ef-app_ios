@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenUnfavouritingEventViewModel_EventDetailInteractorShould: XCTestCase {

    func testUnfavouriteTheEvent() {
        let event = FakeEvent.random
        let context = EventDetailInteractorTestBuilder().build(for: event)
        context.viewModel?.unfavourite()

        XCTAssertEqual(event.favouritedState, .unfavourited)
    }

}
