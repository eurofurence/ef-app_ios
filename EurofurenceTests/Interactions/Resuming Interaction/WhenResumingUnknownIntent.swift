@testable import Eurofurence
import XCTest

class WhenResumingUnknownIntent: XCTestCase {

    func testTheIntentResumerIndicatesTheIntentCannotBeResumed() {
        let intentResumer = InteractionResumer(resumeResponseHandler: CapturingResumeIntentResponseHandler())
        let unknownIntent = String.random
        let activity = IntentActivityDescription(intent: unknownIntent)
        let resumed = intentResumer.resume(activity: activity)
        
        XCTAssertFalse(resumed)
    }

}
