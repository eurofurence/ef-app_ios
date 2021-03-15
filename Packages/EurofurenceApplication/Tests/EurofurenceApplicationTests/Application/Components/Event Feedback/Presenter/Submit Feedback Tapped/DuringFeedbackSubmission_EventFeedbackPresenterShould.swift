import EurofurenceApplication
import EurofurenceModelTestDoubles
import XCTest

class DuringFeedbackSubmission_EventFeedbackPresenterShould: XCTestCase {
    
    func testDisallowFeedbackDismissalUntilTheFeedbackHasBeenSubmittedSuccessfully() {
        assertFeedbackCannotBeDismissed(feedbackResultHandler: { $0?.simulateSuccess() })
    }
    
    func testDisallowFeedbackDismissalUntilTheFeedbackHasBeenSubmittedUnsuccessfully() {
        assertFeedbackCannotBeDismissed(feedbackResultHandler: { $0?.simulateFailure() })
    }
    
    private func assertFeedbackCannotBeDismissed(
        feedbackResultHandler: (FakeEventFeedback?) -> Void,
        line: UInt = #line
    ) {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(
            .dismissalPermitted,
            context.scene.dismissalState,
            "Feedback should be dismissable once the form has loaded",
            line: line
        )
        
        context.scene.simulateFeedbackTextDidChange(.random)
        context.scene.simulateFeedbackRatioDidChange(.random)
        context.scene.simulateSubmitFeedbackTapped()
        
        XCTAssertEqual(
            .dismissalDenied,
            context.scene.dismissalState,
            "Feedback should not be dismissable until it has finished processing",
            line: line
        )
        
        let feedback = context.event.lastGeneratedFeedback
        feedbackResultHandler(feedback)
        
        XCTAssertEqual(
            .dismissalPermitted,
            context.scene.dismissalState,
            "Feedback should be dismissable once it has finished processing",
            line: line
        )
    }

}
