import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForEventRequiringFaceMask_EventDetailViewModelFactoryShould: XCTestCase {
    
    func testProduceSuperSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isFaceMaskRequired = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventFaceMaskMessageViewModel(message: "Face masks are mandatory for this event")

        XCTAssertEqual(expected, visitor.visited(ofKind: EventFaceMaskMessageViewModel.self))
        XCTAssertTrue(
            visitor.does(EventFaceMaskMessageViewModel.self, precede: EventDescriptionViewModel.self)
        )
    }

}
