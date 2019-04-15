import XCTest

class WhenEventFeedbackSubmitsUnsuccessfully_EventFeedbackPresenterShould: XCTestCase {

    func testNotPlaySuccessHaptic() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateSubmitFeedbackTapped()
        context.event.lastGeneratedFeedback?.simulateFailure()
        
        XCTAssertFalse(context.successHaptic.played)
    }

}
