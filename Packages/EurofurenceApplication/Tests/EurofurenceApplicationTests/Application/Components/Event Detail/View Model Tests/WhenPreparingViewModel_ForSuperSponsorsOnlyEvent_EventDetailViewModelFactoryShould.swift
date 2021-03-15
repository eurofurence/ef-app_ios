import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForSuperSponsorsOnlyEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceSuperSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isSuperSponsorOnly = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventSuperSponsorsOnlyWarningViewModel(message: .thisEventIsForSuperSponsorsOnly)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventSuperSponsorsOnlyWarningViewModel.self))
        XCTAssertTrue(
            visitor.does(EventSuperSponsorsOnlyWarningViewModel.self, precede: EventDescriptionViewModel.self)
        )
    }

}
