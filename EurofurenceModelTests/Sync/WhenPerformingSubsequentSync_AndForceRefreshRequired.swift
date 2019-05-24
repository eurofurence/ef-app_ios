import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPerformingSubsequentSync_AndForceRefreshRequired: XCTestCase {

    func testTheAPIShouldPerformFullRefresh() {
        let store = InMemoryDataStore()
        var context = EurofurenceSessionTestBuilder().with(store).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        let forceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        context = EurofurenceSessionTestBuilder().with(store).with(forceRefreshRequired).build()
        context.refreshService.refreshLocalStore(completionHandler: { (_) in })
        
        XCTAssertTrue(context.api.requestedFullStoreRefresh)
    }

}
