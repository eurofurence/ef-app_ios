import EurofurenceModel
import EventDetailComponent
import XCTest

class WhenBuildingEventDetailModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = EventDetailPresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }

}
