@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingOpenCollectThemAllIntent: XCTestCase {
    
    func testTheIntentIsResumed() {
        let resumeResponseHandler = CapturingResumeIntentResponseHandler()
        let intentResumer = InteractionResumer(resumeResponseHandler: resumeResponseHandler)
        let openCollectThemAllIntent = StubOpenCollectThemAllIntentDefinitionProviding()
        let resumed = intentResumer.resume(intent: openCollectThemAllIntent)
        
        XCTAssertTrue(resumed)
        XCTAssertTrue(resumeResponseHandler.didResumeCollectThemAllIntent)
    }
    
}
