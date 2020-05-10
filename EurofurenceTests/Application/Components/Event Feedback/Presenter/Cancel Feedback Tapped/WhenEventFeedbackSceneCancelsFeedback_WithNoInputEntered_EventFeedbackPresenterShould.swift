import XCTest

class WhenEventFeedbackSceneCancelsFeedback_WithNoInputEntered_EventFeedbackPresenterShould: XCTestCase {

    func testExitTheFlow() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateCancelFeedbackTapped()
        
        XCTAssertTrue(context.delegate.dismissed)
    }
    
    func testNotShowTheConfirmCancelFeedbackPrompt() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateCancelFeedbackTapped()
        
        XCTAssertFalse(context.scene.confirmCancellationAlertPresented)
    }

}
