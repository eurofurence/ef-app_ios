import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenEventIsAcceptingFeedback_EventDetailViewModelFactoryShould: XCTestCase {

    func testIncludeLeaveFeedbackActionAfterSummary() {
        let event = FakeEvent.random
        event.isAcceptingFeedback = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: LeaveFeedbackActionViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        command?.describe(to: actionVisitor)
        
        XCTAssertEqual(actionVisitor.actionTitle, "Leave Feedback")
    }
    
    func testInvokingLeaveFeedbackActionCommand() {
        let event = FakeEvent.random
        event.isAcceptingFeedback = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let viewModelDelegate = CapturingEventDetailViewModelDelegate()
        context.viewModel.setDelegate(viewModelDelegate)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: LeaveFeedbackActionViewModel.self)
        command?.perform()
        
        XCTAssertTrue(viewModelDelegate.leaveFeedbackInvoked)
    }

}
