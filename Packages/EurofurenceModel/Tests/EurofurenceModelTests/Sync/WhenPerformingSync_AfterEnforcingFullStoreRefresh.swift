import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPerformingSync_AfterEnforcingFullStoreRefresh: XCTestCase {

    func testTheAPIShouldPerformDeltaUpdate() {
        let forceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        let context = EurofurenceSessionTestBuilder().with(forceRefreshRequired).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        
        XCTAssertFalse(context.api.requestedFullStoreRefresh)
    }

}
