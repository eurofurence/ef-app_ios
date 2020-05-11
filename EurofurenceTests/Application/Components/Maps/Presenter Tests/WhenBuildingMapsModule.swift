import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingMapsModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = MapsPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }

    func testTheMapsTitleIsAppliedToTheScene() {
        let context = MapsPresenterTestBuilder().build()
        XCTAssertEqual(.maps, context.scene.capturedTitle)
    }

}
