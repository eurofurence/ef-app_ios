@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForArtShowEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceArtShowComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isArtShow = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventArtShowMessageViewModel(message: .artShow)

        XCTAssertEqual([expected], visitor.visitedViewModels)
    }

}
