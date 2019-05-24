@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForMainStageEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceMainStageComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isMainStage = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventMainStageMessageViewModel(message: .mainStageEvent)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventMainStageMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventMainStageMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
