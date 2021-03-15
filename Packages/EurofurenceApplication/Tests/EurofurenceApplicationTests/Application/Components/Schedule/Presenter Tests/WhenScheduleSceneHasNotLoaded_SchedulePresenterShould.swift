import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenScheduleSceneHasNotLoaded_SchedulePresenterShould: XCTestCase {

    func testNotBindAnyItems() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertTrue(context.scene.boundItemsPerSection.isEmpty)
    }

}
