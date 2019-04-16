@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForDealersDenEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceDealersDenHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isDealersDen = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel.describe(componentAt: 2, to: visitor)
        let expected = EventDealersDenMessageViewModel(message: .dealersDen)

        XCTAssertEqual([expected], visitor.visitedViewModels)
    }

}
