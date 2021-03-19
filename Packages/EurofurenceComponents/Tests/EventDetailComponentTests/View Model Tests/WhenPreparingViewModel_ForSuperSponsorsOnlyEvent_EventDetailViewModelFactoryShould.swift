import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForSuperSponsorsOnlyEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceSuperSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isSuperSponsorOnly = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventSuperSponsorsOnlyWarningViewModel(message: "Admittance for Super-Sponsors only")

        XCTAssertEqual(expected, visitor.visited(ofKind: EventSuperSponsorsOnlyWarningViewModel.self))
        XCTAssertTrue(
            visitor.does(EventSuperSponsorsOnlyWarningViewModel.self, precede: EventDescriptionViewModel.self)
        )
    }

}
