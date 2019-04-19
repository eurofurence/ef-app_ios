import XCTest

class WhenEventFeedbackSubmitsUnsuccessfully_EventFeedbackPresenterShould: XCTestCase {
    
    var context: EventFeedbackPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateSubmitFeedbackTapped()
        context.event.lastGeneratedFeedback?.simulateFailure()
    }
    
    func testShowFailurePrompt() {
        XCTAssertTrue(context.scene.didShowFailurePrompt)
    }
    
    func testPlayFailureHaptic() {
        XCTAssertTrue(context.failureHaptic.played)
    }

    func testNotPlaySuccessHaptic() {
        XCTAssertFalse(context.successHaptic.played)
    }
    
    func testShowTheFeedbackForm() {
        XCTAssertEqual(context.scene.feedbackState, .feedbackForm)
    }

}
