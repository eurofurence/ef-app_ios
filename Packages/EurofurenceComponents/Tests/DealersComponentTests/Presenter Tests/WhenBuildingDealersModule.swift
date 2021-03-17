import DealersComponent
import EurofurenceModel
import XCTest

class WhenBuildingDealersModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = DealersPresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }

    func testTheSceneIsToldToShowTheDealersTitle() {
        let context = DealersPresenterTestBuilder().build()
        XCTAssertEqual("Dealers", context.scene.capturedTitle)
    }

}
