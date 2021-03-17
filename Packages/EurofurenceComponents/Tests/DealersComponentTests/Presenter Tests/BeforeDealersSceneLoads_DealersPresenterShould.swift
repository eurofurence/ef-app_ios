import DealersComponent
import EurofurenceModel
import XCTest

class BeforeDealersSceneLoads_DealersPresenterShould: XCTestCase {

    func testNotBindUponTheScene() {
        let context = DealersPresenterTestBuilder().build()
        XCTAssertTrue(context.scene.capturedDealersPerSectionToBind.isEmpty)
    }

}
