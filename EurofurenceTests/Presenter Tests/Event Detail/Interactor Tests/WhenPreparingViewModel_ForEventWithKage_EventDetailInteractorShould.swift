@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventWithKage_EventDetailInteractorShould: XCTestCase {

    func testProduceKageHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isKageEvent = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel.describe(componentAt: 2, to: visitor)
        let expected = EventKageMessageViewModel(message: .kageGuestMessage)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventKageMessageViewModel.self))
    }

}
