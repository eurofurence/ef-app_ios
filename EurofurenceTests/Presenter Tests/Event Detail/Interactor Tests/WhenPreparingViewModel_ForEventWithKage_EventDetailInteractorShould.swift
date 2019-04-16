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
        visitor.consume(contentsOf: context.viewModel)
        let expected = EventKageMessageViewModel(message: .kageGuestMessage)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventKageMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventKageMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
