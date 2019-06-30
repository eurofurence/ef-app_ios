@testable import Eurofurence
import XCTest

class WhenResumingUnknownIntent: XCTestCase {

    func testTheIntentResumerIndicatesTheIntentCannotBeResumed() {
        let intentResumer = ActivityResumer(contentLinksService: StubContentLinksService(), contentRouter: CapturingContentRouter())
        let unknownIntent = String.random
        let activity = IntentActivityDescription(intent: unknownIntent)
        let resumed = intentResumer.resume(activity: activity)
        
        XCTAssertFalse(resumed)
    }

}
