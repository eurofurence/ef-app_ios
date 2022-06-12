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

}
