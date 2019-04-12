import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPerformingFullStoreRefresh_ApplicationShould: XCTestCase {

    func testRequestSyncWithoutDeltas() {
        let dataStore = FakeDataStore(response: .randomWithoutDeletions)
        let fullStoreRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        var context = EurofurenceSessionTestBuilder().with(dataStore).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        context = EurofurenceSessionTestBuilder().with(dataStore).with(fullStoreRefreshRequired).build()
        _ = context.refreshService.refreshLocalStore { (_) in }

        XCTAssertTrue(context.api.requestedFullStoreRefresh)
    }

}
