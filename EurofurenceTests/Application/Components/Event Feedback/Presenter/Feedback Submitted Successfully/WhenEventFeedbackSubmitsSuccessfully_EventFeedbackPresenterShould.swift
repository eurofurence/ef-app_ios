import XCTest

class WhenEventFeedbackSubmitsSuccessfully_EventFeedbackPresenterShould: XCTestCase {
    
    var context: EventFeedbackPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateSubmitFeedbackTapped()
        context.event.lastGeneratedFeedback?.simulateSuccess()
    }

    func testEnterSuccessState() {
        XCTAssertEqual(context.scene.feedbackState, .success)
        XCTAssertTrue(context.successHaptic.played)
        XCTAssertFalse(context.failureHaptic.played)
    }
    
    func testRequestDismissalAfterSuccessWaitingRuleElapses() {
        XCTAssertFalse(context.delegate.dismissed)
        
        context.successWaitingRule.elapse()
        
        XCTAssertTrue(context.delegate.dismissed)
    }

}
