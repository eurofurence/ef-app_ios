import EurofurenceModel
import XCTest

class WhenPerformingSubsequentSync_ApplicationShould: XCTestCase {

    func testProvideTheLastSyncTimeToTheSyncAPI() {
        let context = EurofurenceSessionTestBuilder().build()
        let expected = Date.random
        context.clock.tickTime(to: expected)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)
        context.refreshLocalStore()

        XCTAssertEqual(expected, context.api.capturedLastSyncTime)
    }

    func testCompleteSyncWhenNotRedownloadingAnyImages() {
        let context = EurofurenceSessionTestBuilder().build()
        let expected = Date.random
        context.clock.tickTime(to: expected)
        context.refreshLocalStore()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.api.simulateSuccessfulSync(syncResponse)
        var didFinishSync = false
        context.refreshLocalStore { (_) in didFinishSync = true }
        context.api.simulateSuccessfulSync(syncResponse)

        XCTAssertTrue(didFinishSync)
    }

    func testIndicateCompleteProgressIfNothingToDownload() {
        let context = EurofurenceSessionTestBuilder().build()
        let expected = Date.random
        context.clock.tickTime(to: expected)
        context.refreshLocalStore()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.api.simulateSuccessfulSync(syncResponse)
        let progress = context.refreshLocalStore()
        context.api.simulateSuccessfulSync(syncResponse)

        XCTAssertEqual(1.0, progress.fractionCompleted, accuracy: .ulpOfOne)
    }

}
