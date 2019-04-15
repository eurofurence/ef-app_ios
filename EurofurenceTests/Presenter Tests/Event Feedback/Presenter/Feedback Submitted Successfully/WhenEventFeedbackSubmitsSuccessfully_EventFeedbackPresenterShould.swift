import XCTest

class WhenEventFeedbackSubmitsSuccessfully_EventFeedbackPresenterShould: XCTestCase {

    func testShowSuccessWhenFeedbackSubmitsSuccessfully() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateSubmitFeedbackTapped()
        context.event.lastGeneratedFeedback?.simulateSuccess()
        
        XCTAssertEqual(context.scene.feedbackState, .success)
    }

}
