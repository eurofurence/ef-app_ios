import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenUpgradingBetweenAppVersions_ApplicationShould: XCTestCase {

    func testIndicateStoreIsStale() {
        let forceUpgradeRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        let presentDataStore = InMemoryDataStore(response: .randomWithoutDeletions)
        presentDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }
        
        let context = EurofurenceSessionTestBuilder().with(presentDataStore).with(forceUpgradeRequired).build()
        let sessionStateObserver = CapturingSessionStateObserver()
        context.sessionStateService.add(observer: sessionStateObserver)

        XCTAssertEqual(EurofurenceSessionState.stale, sessionStateObserver.state)
    }

    func testAlwaysEnquireWhetherUpgradeRequiredEvenWhenRefreshWouldOccurByPreference() {
        let forceUpgradeRequired = CapturingForceRefreshRequired()
        let presentDataStore = InMemoryDataStore(response: .randomWithoutDeletions)
        let preferences = StubUserPreferences()
        preferences.refreshStoreOnLaunch = true
        let context = EurofurenceSessionTestBuilder()
            .with(preferences)
            .with(presentDataStore)
            .with(forceUpgradeRequired)
            .build()
        
        let sessionStateObserver = CapturingSessionStateObserver()
        context.sessionStateService.add(observer: sessionStateObserver)

        XCTAssertTrue(forceUpgradeRequired.wasEnquiredWhetherForceRefreshRequired)
    }

    func testDetermineWhetherForceRefreshRequiredBeforeFirstEverSync() {
        let forceUpgradeRequired = CapturingForceRefreshRequired()
        let absentDataStore = InMemoryDataStore()
        let preferences = StubUserPreferences()
        preferences.refreshStoreOnLaunch = true
        let context = EurofurenceSessionTestBuilder()
            .with(preferences)
            .with(absentDataStore)
            .with(forceUpgradeRequired)
            .build()
        
        let sessionStateObserver = CapturingSessionStateObserver()
        context.sessionStateService.add(observer: sessionStateObserver)

        XCTAssertTrue(forceUpgradeRequired.wasEnquiredWhetherForceRefreshRequired)
    }

}
