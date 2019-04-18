@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenEventIsAcceptingFeedback_EventDetailInteractorShould: XCTestCase {

    func testIncludeLeaveFeedbackActionAfterSummary() {
        let event = FakeEvent.random
        event.isAcceptingFeedback = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        
        let command = visitor.visited(ofKind: LeaveFeedbackActionViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, String.leaveFeedback)
    }

}
