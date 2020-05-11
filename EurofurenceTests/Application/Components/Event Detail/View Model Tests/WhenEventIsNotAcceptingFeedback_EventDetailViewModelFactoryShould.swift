import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenEventIsNotAcceptingFeedback_EventDetailViewModelFactoryShould: XCTestCase {

    func testNotIncludeLeaveFeedbackActionAfterSummary() {
        let event = FakeEvent.random
        event.isAcceptingFeedback = false
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: LeaveFeedbackActionViewModel.self)
        XCTAssertNil(command)
    }

}
