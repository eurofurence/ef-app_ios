@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingMapDetailModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = MapDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }

}
