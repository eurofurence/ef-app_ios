@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenUnfavouritingEventViewModel_EventDetailInteractorShould: XCTestCase {

    func testUnfavouriteTheEvent() {
        let event = FakeEvent.random
        event.favourite()
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let toggleFavouriteCommand = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        toggleFavouriteCommand?.perform()

        XCTAssertEqual(event.favouritedState, .unfavourited)
    }

}
