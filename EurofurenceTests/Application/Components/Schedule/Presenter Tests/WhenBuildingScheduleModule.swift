import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingScheduleModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }

    func testTheSceneIsToldToShowTheScheduleTitle() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertEqual(.schedule, context.scene.capturedTitle)
    }

}
