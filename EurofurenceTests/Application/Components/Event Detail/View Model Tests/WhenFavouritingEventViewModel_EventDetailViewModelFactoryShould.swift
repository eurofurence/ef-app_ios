import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFavouritingEventViewModel_EventDetailViewModelFactoryShould: XCTestCase {

    func testTellTheEventToBeFavourited() {
        let event = FakeEvent.random
        event.unfavourite()
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let toggleFavouriteCommand = visitor.visited(ofKind: ToggleEventFavouriteStateViewModel.self)
        toggleFavouriteCommand?.perform()

        XCTAssertEqual(event.favouritedState, .favourited)
    }

}
