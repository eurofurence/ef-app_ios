@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenCollectThemAllSceneLoads_PresenterShould: XCTestCase {

    func testTellTheSceneToLoadTheURLFromTheCollectThemAllService() {
        let context = CollectThemAllPresenterTestBuilder().build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(context.service.urlRequest, context.scene.capturedURLRequest)
    }
    
    func testRecordCollectThemAllInteraction() {
        let context = CollectThemAllPresenterTestBuilder().build()
        
        XCTAssertFalse(context.collectThemAllInteractionRecorder.didRecordInteraction)
        
        context.simulateSceneDidLoad()
        
        XCTAssertTrue(context.collectThemAllInteractionRecorder.didRecordInteraction)
    }

}
