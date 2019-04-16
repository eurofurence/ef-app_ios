@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForSponsorsOnlyEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.random
        event.isSponsorOnly = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel.describe(componentAt: 2, to: visitor)
        let expected = EventSponsorsOnlyWarningViewModel(message: .thisEventIsForSponsorsOnly)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventSponsorsOnlyWarningViewModel.self))
    }

}
