import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForArtShowEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceArtShowComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isArtShow = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventArtShowMessageViewModel(message: .artShow)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventArtShowMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventArtShowMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
