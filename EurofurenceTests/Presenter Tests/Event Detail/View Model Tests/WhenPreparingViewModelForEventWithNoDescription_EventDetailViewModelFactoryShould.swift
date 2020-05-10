@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModelForEventWithNoDescription_EventDetailViewModelFactoryShould: XCTestCase {

    func testNotContainDescription() {
        let event = FakeEvent.random
        event.eventDescription = ""

        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()

        XCTAssertNil(visitor.visited(ofKind: EventDescriptionViewModel.self))
    }

}
