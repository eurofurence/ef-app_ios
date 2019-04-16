@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForSuperSponsorsOnlyEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceSuperSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isSuperSponsorOnly = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        let expected = EventSuperSponsorsOnlyWarningViewModel(message: .thisEventIsForSuperSponsorsOnly)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventSuperSponsorsOnlyWarningViewModel.self))
    }

}
