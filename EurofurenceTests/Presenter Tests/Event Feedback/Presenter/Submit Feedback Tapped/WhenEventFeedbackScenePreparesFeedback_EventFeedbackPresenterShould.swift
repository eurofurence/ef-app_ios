@testable import Eurofurence
import XCTest

class WhenEventFeedbackScenePreparesFeedback_EventFeedbackPresenterShould: XCTestCase {

    func testSubmitTheFeedback() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        let expectedFeedback = String.random
        let sceneRating = Float.random
        let expectedRating = Int((sceneRating * 10) / 2)
        context.scene.simulateFeedbackTextDidChange(expectedFeedback)
        context.scene.simulateFeedbackRatioDidChange(sceneRating)
        context.scene.simulateSubmitFeedbackTapped()
        
        let feedback = context.event.lastGeneratedFeedback
        
        XCTAssertEqual(feedback?.feedback, expectedFeedback)
        XCTAssertEqual(feedback?.rating, expectedRating)
        XCTAssertEqual(feedback?.state, .submitted)
    }
    
    func testShowProgress() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateSubmitFeedbackTapped()
        
        XCTAssertEqual(context.scene.feedbackState, .inProgress)
    }
    
    func testDisableNavigationItems() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateSubmitFeedbackTapped()
        
        XCTAssertEqual(context.scene.navigationControlsState, .disabled)
    }

}
