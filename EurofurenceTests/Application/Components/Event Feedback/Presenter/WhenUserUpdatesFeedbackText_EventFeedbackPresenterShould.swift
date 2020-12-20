import Eurofurence
import XCTest

class WhenUserUpdatesFeedbackText_EventFeedbackPresenterShould: XCTestCase {
    
    func testPreventDismissalWhenTextIsNonEmpty() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        let feedback = "This event is very cool and good"
        context.scene.simulateFeedbackTextDidChange(feedback)
        
        XCTAssertEqual(.dismissalDenied, context.scene.dismissalState)
    }
    
    func testPermitDissmisalWhenTextIsEmpty() {
        let context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        context.scene.simulateFeedbackTextDidChange("This event is very cool and good")
        context.scene.simulateFeedbackTextDidChange("")
        
        XCTAssertEqual(.dismissalPermitted, context.scene.dismissalState)
    }

}
