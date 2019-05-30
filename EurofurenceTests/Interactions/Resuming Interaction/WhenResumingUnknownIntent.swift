@testable import Eurofurence
import XCTest

class WhenResumingUnknownIntent: XCTestCase {

    func testTheIntentResumerIndicatesTheIntentCannotBeResumed() {
        let intentResumer = InteractionResumer(resumeResponseHandler: CapturingResumeIntentResponseHandler())
        let unknownIntent = String.random
        let resumed = intentResumer.resume(intent: unknownIntent)
        
        XCTAssertFalse(resumed)
    }

}
