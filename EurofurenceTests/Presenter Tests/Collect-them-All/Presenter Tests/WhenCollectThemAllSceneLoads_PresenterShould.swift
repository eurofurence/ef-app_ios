@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenCollectThemAllSceneLoads_PresenterShould: XCTestCase {

    func testTellTheSceneToLoadTheURLFromTheCollectThemAllService() {
        let context = CollectThemAllPresenterTestBuilder().build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(context.service.urlRequest, context.scene.capturedURLRequest)
    }

}
