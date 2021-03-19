import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForMainStageEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceMainStageComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isMainStage = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventMainStageMessageViewModel(message: "Main Stage Event")

        XCTAssertEqual(expected, visitor.visited(ofKind: EventMainStageMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventMainStageMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
