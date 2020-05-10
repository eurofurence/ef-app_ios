@testable import Eurofurence
import XCTest

class WhenEventFeedbackSceneCancelsFeedback_WithFeedbackEntered_EventFeedbackPresenterShould: XCTestCase {
    
    func testNotExitTheFlow() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateFeedbackTextDidChange("Some feedback")
        context.scene.simulateCancelFeedbackTapped()
        
        XCTAssertFalse(context.delegate.dismissed)
    }

    func testShowTheConfirmCancelFeedbackPrompt() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateFeedbackTextDidChange("Some feedback")
        context.scene.simulateCancelFeedbackTapped()
        
        XCTAssertTrue(context.scene.confirmCancellationAlertPresented)
    }

}
