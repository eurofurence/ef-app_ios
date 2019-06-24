import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRequestingStoreRefresh_MultipleTimes: XCTestCase {

    func testTheSameProgressIsReturned() {
        let context = EurofurenceSessionTestBuilder().build()
        let firstProgress = context.refreshLocalStore()
        let secondProgress = context.refreshLocalStore()
        
        XCTAssertTrue(firstProgress === secondProgress, "The same refresh task should use the same Progress")
    }
    
    func testTheAPIIsOnlyHitOnce() {
        let api = OnlyToldToRefreshOnceMockAPI()
        let context = EurofurenceSessionTestBuilder().with(api).build()
        context.refreshLocalStore()
        context.refreshLocalStore()
        
        XCTAssertTrue(api.toldToRefreshOnlyOnce, "Trying to refresh while already refreshing should coalesce the requests")
    }
    
    func testEncounteringAPIErrorShouldPermitNewRequests() {
        let context = EurofurenceSessionTestBuilder().build()
        let firstProgress = context.refreshLocalStore()
        context.simulateSyncAPIError()
        let secondProgress = context.refreshLocalStore()
        
        XCTAssertFalse(firstProgress === secondProgress, "API errors during a sync should stop coalescing sync requests")
    }
    
    func testConventionIdentifierMismatchesShouldPermitNewRequests() {
        let initialCharacteristics = ModelCharacteristics.randomWithoutDeletions
        let store = InMemoryDataStore(response: initialCharacteristics)
        let context = EurofurenceSessionTestBuilder().with(store).build()
        let firstProgress = context.refreshLocalStore()
        var mismatchedConventionIdentifierCharacteristics = ModelCharacteristics.randomWithoutDeletions
        mismatchedConventionIdentifierCharacteristics.conventionIdentifier = .random
        context.simulateSyncSuccess(mismatchedConventionIdentifierCharacteristics)
        let secondProgress = context.refreshLocalStore()
        
        XCTAssertFalse(firstProgress === secondProgress, "CID mismatches should stop coalescing sync requests")
    }

}
