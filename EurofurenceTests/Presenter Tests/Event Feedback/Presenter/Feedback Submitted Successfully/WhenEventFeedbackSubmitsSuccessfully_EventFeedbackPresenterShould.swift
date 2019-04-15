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

    func testShowSuccess() {
        XCTAssertEqual(context.scene.feedbackState, .success)
    }
    
    func testPlaySuccessHaptic() {
        XCTAssertTrue(context.successHaptic.played)
    }
    
    func testNotPlayFailureHaptic() {
        XCTAssertFalse(context.failureHaptic.played)
    }

}
