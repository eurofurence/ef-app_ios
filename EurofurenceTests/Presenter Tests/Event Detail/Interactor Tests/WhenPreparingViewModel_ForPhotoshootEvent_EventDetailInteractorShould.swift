@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForPhotoshootEvent_EventDetailInteractorShould: XCTestCase {

    func testProducePhotoshootHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isPhotoshoot = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventPhotoshootMessageViewModel(message: .photoshoot)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventPhotoshootMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventPhotoshootMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
