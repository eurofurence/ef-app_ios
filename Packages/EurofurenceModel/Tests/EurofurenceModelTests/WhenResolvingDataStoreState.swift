import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenResolvingDataStoreState: XCTestCase {

    func testStoreWithNoLastRefreshTimeIsAbsent() {
        let capturingDataStore = InMemoryDataStore()
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).build()
        let sessionStateObserver = CapturingSessionStateObserver()
        context.sessionStateService.add(observer: sessionStateObserver)

        XCTAssertEqual(.uninitialized, sessionStateObserver.state)
    }

    func testStoreWithLastRefreshDateWithRefreshOnLaunchEnabledIsStale() {
        let capturingDataStore = InMemoryDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).with(userPreferences).build()
        let sessionStateObserver = CapturingSessionStateObserver()
        context.sessionStateService.add(observer: sessionStateObserver)

        XCTAssertEqual(.stale, sessionStateObserver.state)
    }

    func testStoreWithLastRefreshDateWithRefreshOnLaunchDisabledIsAvailable() {
        let capturingDataStore = InMemoryDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = false
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).with(userPreferences).build()
        let sessionStateObserver = CapturingSessionStateObserver()
        context.sessionStateService.add(observer: sessionStateObserver)

        XCTAssertEqual(.initialized, sessionStateObserver.state)
    }
    
    func testStoreBeginsUninitializedThenBecomesInitialized() {
        let capturingDataStore = InMemoryDataStore()
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).build()
        let sessionStateObserver = CapturingSessionStateObserver()
        context.sessionStateService.add(observer: sessionStateObserver)
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        
        XCTAssertEqual(.initialized, sessionStateObserver.state)
    }
    
    func testStoreIsInitialized_WhenRefreshOccurs_StoreDoesNotReentrantlyBecomeInitialized() {
        let capturingDataStore = InMemoryDataStore()
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).build()
        let sessionStateObserver = OnlyEntersInitializedStateOnce()
        context.sessionStateService.add(observer: sessionStateObserver)
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        
        XCTAssertFalse(sessionStateObserver.enteredInitializedMoreThanOnce)
    }
    
    func testNoRepeatInitializationNotificationsWhenStoreWasAlreadyInitialized() {
        let capturingDataStore = InMemoryDataStore(response: .randomWithoutDeletions)
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).build()
        let sessionStateObserver = OnlyEntersInitializedStateOnce()
        context.sessionStateService.add(observer: sessionStateObserver)
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        
        XCTAssertFalse(sessionStateObserver.enteredInitializedMoreThanOnce)
    }
    
    private class OnlyEntersInitializedStateOnce: CapturingSessionStateObserver {
        private(set) var enteredInitializedMoreThanOnce = false
        override func sessionStateDidChange(_ newState: EurofurenceSessionState) {
            enteredInitializedMoreThanOnce = self.state == .initialized && newState == .initialized
            super.sessionStateDidChange(newState)
        }
    }

}
