import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenRequestingStoreRefresh_MultipleTimes: XCTestCase {

    func testTheSameProgressIsReturned() {
        let context = EurofurenceSessionTestBuilder().build()
        let firstProgress = context.refreshLocalStore()
        let secondProgress = context.refreshLocalStore()
        
        XCTAssertTrue(firstProgress === secondProgress, "The same refresh task should use the same Progress")
    }
    
    func testOnlyOneLongRunningTaskIsManaged() {
        let longRunningTaskManager = JournallingLongRunningTaskManager()
        let context = EurofurenceSessionTestBuilder().with(longRunningTaskManager).build()
        context.refreshLocalStore()
        context.refreshLocalStore()
        
        XCTAssertEqual(
            1,
            longRunningTaskManager.longRunningTaskCount,
            "Only one task should start when coalescing multiple refreshes"
        )
    }
    
    func testObserversAreOnlyToldAboutTheRefreshStartingOnce() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = JournallingRefreshServiceObserver()
        context.refreshService.add(observer)
        context.refreshLocalStore()
        context.refreshLocalStore()
        
        XCTAssertEqual(
            1,
            observer.numberOfTimesToldDidBeginRefreshing,
            "Observers should not be told about refreshes that are coalesced"
        )
    }
    
    func testTheAPIIsOnlyHitOnce() {
        let api = OnlyToldToRefreshOnceMockAPI()
        let context = EurofurenceSessionTestBuilder().with(api).build()
        context.refreshLocalStore()
        context.refreshLocalStore()
        
        XCTAssertTrue(
            api.toldToRefreshOnlyOnce,
            "Trying to refresh while already refreshing should coalesce the requests"
        )
    }
    
    func testEncounteringAPIErrorShouldPermitNewRequests() {
        let context = EurofurenceSessionTestBuilder().build()
        let firstProgress = context.refreshLocalStore()
        context.simulateSyncAPIError()
        let secondProgress = context.refreshLocalStore()
        
        XCTAssertFalse(
            firstProgress === secondProgress,
            "API errors during a sync should stop coalescing sync requests"
        )
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
