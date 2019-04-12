import EurofurenceModel
import XCTest

class WhenPerformingSync_BeforeImageDownload: XCTestCase {

    func testTheProgressShouldBeIndeterminate() {
        let context = EurofurenceSessionTestBuilder().build()
        let progress = context.refreshLocalStore()

        XCTAssertTrue(progress.isIndeterminate)
        XCTAssertEqual(progress.totalUnitCount, -1)
        XCTAssertEqual(progress.completedUnitCount, -1)
    }

}
