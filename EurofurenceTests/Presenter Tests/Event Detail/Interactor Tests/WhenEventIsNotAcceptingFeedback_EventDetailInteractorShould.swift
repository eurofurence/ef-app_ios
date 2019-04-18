@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenEventIsNotAcceptingFeedback_EventDetailInteractorShould: XCTestCase {

    func testNotIncludeLeaveFeedbackActionAfterSummary() {
        let event = FakeEvent.random
        event.isAcceptingFeedback = false
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        
        let command = visitor.visited(ofKind: LeaveFeedbackActionViewModel.self)
        XCTAssertNil(command)
    }

}
