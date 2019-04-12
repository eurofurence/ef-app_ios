@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForPhotoshootEvent_EventDetailInteractorShould: XCTestCase {

    func testProducePhotoshootHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isPhotoshoot = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventPhotoshootMessageViewModel(message: .photoshoot)

        XCTAssertEqual([expected], visitor.visitedViewModels)
    }

}
