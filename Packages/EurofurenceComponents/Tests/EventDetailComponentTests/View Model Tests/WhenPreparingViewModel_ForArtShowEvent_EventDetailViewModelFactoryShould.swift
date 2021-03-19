import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForArtShowEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceArtShowComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isArtShow = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventArtShowMessageViewModel(message: "Art Show")

        XCTAssertEqual(expected, visitor.visited(ofKind: EventArtShowMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventArtShowMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
