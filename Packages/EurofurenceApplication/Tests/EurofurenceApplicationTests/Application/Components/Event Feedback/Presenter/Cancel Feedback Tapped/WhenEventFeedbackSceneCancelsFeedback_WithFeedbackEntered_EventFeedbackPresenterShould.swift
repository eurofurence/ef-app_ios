import EurofurenceApplication
import XCTest

class WhenEventFeedbackSceneCancelsFeedback_WithFeedbackEntered_EventFeedbackPresenterShould: XCTestCase {

    func testShowTheConfirmCancelFeedbackPrompt() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateFeedbackTextDidChange("Some feedback")
        context.scene.simulateCancelFeedbackTapped()
        
        XCTAssertTrue(context.scene.confirmCancellationAlertPresented)
        XCTAssertFalse(context.delegate.dismissed)
    }

}
