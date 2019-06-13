import EurofurenceModel
import XCTest

class WhenPerformingSync_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
    }

    func testTellRefreshServiceObserversRefreshStarted() {
        context.refreshLocalStore()
        XCTAssertEqual(context.refreshObserver.state, .refreshing)
    }

    func testTellRefreshServiceObserversWhenSyncFinishesSuccessfully() {
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertEqual(context.refreshObserver.state, .finishedRefreshing)
    }

    func testTellRefreshServiceObserversWhenSyncFails() {
        context.refreshLocalStore()
        context.api.simulateUnsuccessfulSync()

        XCTAssertEqual(context.refreshObserver.state, .finishedRefreshing)
    }

}
