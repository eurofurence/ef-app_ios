import EurofurenceModel
import XCTest

class BeforeSyncInitiated_ApplicationShould: XCTestCase {

    func testNotRequestLongRunningTaskToBegin() {
        let context = EurofurenceSessionTestBuilder().build()
        XCTAssertFalse(context.longRunningTaskManager.didBeginTask)
    }

}
