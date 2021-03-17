import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenResolvingDataStoreState: XCTestCase {

    func testStoreWithNoLastRefreshTimeIsAbsent() {
        let capturingDataStore = InMemoryDataStore()
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).build()
        var state: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { state = $0 }

        XCTAssertEqual(.uninitialized, state)
    }

    func testStoreWithLastRefreshDateWithRefreshOnLaunchEnabledIsStale() {
        let capturingDataStore = InMemoryDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { state = $0 }

        XCTAssertEqual(.stale, state)
    }

    func testStoreWithLastRefreshDateWithRefreshOnLaunchDisabledIsAvailable() {
        let capturingDataStore = InMemoryDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = false
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { state = $0 }

        XCTAssertEqual(.initialized, state)
    }

}
