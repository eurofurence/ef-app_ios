@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenEventIsAcceptingFeedback_EventDetailInteractorShould: XCTestCase {

    func testIncludeLeaveFeedbackActionAfterSummary() {
        let event = FakeEvent.random
        event.isAcceptingFeedback = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: LeaveFeedbackActionViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, String.leaveFeedback)
    }
    
    func testInvokingLeaveFeedbackActionCommand() {
        let event = FakeEvent.random
        event.isAcceptingFeedback = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let viewModelDelegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(viewModelDelegate)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: LeaveFeedbackActionViewModel.self)
        command?.perform()
        
        XCTAssertTrue(viewModelDelegate.leaveFeedbackInvoked)
    }

}
