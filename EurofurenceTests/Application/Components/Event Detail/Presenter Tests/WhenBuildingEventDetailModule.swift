import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingEventDetailModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = EventDetailPresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }

}
