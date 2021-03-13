import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBuildingMapDetailComponent: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = MapDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }

}
