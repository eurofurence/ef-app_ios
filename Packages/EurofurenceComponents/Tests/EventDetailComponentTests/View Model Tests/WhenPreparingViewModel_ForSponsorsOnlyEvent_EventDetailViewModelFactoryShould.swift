import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForSponsorsOnlyEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.random
        event.isSponsorOnly = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventSponsorsOnlyWarningViewModel(message: "Admittance for Sponsors and Super-Sponsors only")

        XCTAssertEqual(expected, visitor.visited(ofKind: EventSponsorsOnlyWarningViewModel.self))
        XCTAssertTrue(visitor.does(EventSponsorsOnlyWarningViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
