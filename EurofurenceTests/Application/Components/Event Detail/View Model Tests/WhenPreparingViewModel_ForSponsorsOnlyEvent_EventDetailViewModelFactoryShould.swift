@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForSponsorsOnlyEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.random
        event.isSponsorOnly = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventSponsorsOnlyWarningViewModel(message: .thisEventIsForSponsorsOnly)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventSponsorsOnlyWarningViewModel.self))
        XCTAssertTrue(visitor.does(EventSponsorsOnlyWarningViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
