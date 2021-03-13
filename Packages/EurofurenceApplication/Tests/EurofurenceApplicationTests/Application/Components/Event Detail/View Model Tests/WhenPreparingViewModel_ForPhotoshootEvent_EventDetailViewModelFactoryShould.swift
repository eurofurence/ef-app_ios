import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForPhotoshootEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProducePhotoshootHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isPhotoshoot = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventPhotoshootMessageViewModel(message: .photoshoot)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventPhotoshootMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventPhotoshootMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
