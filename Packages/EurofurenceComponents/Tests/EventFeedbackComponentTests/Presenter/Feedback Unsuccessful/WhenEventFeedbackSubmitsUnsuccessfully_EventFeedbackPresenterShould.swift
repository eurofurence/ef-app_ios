import XCTest

class WhenEventFeedbackSubmitsUnsuccessfully_EventFeedbackPresenterShould: XCTestCase {
    
    func testEnterFailureState() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateSubmitFeedbackTapped()
        context.event.lastGeneratedFeedback?.simulateFailure()
        
        XCTAssertTrue(context.scene.didShowFailurePrompt)
        XCTAssertTrue(context.failureHaptic.played)
        XCTAssertFalse(context.successHaptic.played)
        XCTAssertEqual(context.scene.navigationControlsState, .enabled)
        XCTAssertEqual(context.scene.feedbackState, .feedbackForm)
    }

}
