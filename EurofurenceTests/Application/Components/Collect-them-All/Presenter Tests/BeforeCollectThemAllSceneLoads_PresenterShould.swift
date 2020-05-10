import Eurofurence
import EurofurenceModel
import XCTest

class BeforeCollectThemAllSceneLoads_PresenterShould: XCTestCase {

    func testNotTellTheSceneToLoadTheGameRequest() {
        let context = CollectThemAllPresenterTestBuilder().build()
        XCTAssertNil(context.scene.capturedURLRequest)
    }

}
