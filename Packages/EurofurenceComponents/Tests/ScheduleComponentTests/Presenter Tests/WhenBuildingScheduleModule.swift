import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class WhenBuildingScheduleModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }

    func testTheSceneIsToldToShowTheScheduleTitle() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertEqual("Schedule", context.scene.capturedTitle)
    }

}
