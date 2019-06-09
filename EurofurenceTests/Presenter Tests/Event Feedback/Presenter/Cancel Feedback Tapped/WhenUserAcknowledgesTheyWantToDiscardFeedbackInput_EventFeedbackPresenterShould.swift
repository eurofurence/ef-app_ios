@testable import Eurofurence
import XCTest

class WhenUserAcknowledgesTheyWantToDiscardFeedbackInput_EventFeedbackPresenterShould: XCTestCase {

    func testExitTheFlow() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateFeedbackTextDidChange("Some feedback")
        context.scene.simulateCancelFeedbackTapped()
        context.scene.simulateUserWantsToDiscardFeedbackInput()
        
        XCTAssertTrue(context.delegate.dismissed)
    }

}
