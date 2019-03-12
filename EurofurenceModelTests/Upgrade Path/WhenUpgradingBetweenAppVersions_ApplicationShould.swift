//
//  WhenUpgradingBetweenAppVersions_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenUpgradingBetweenAppVersions_ApplicationShould: XCTestCase {

    func testIndicateStoreIsStale() {
        let forceUpgradeRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        let presentDataStore = FakeDataStore()
        presentDataStore.save(.randomWithoutDeletions)
        let context = EurofurenceSessionTestBuilder().with(presentDataStore).with(forceUpgradeRequired).build()
        var dataStoreState: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { dataStoreState = $0 }

        XCTAssertEqual(EurofurenceSessionState.stale, dataStoreState)
    }

    func testAlwaysEnquireWhetherUpgradeRequiredEvenWhenRefreshWouldOccurByPreference() {
        let forceUpgradeRequired = CapturingForceRefreshRequired()
        let presentDataStore = FakeDataStore()
        presentDataStore.save(.randomWithoutDeletions)
        let preferences = StubUserPreferences()
        preferences.refreshStoreOnLaunch = true
        let context = EurofurenceSessionTestBuilder().with(preferences).with(presentDataStore).with(forceUpgradeRequired).build()
        context.sessionStateService.determineSessionState { (_) in }

        XCTAssertTrue(forceUpgradeRequired.wasEnquiredWhetherForceRefreshRequired)
    }

    func testDetermineWhetherForceRefreshRequiredBeforeFirstEverSync() {
        let forceUpgradeRequired = CapturingForceRefreshRequired()
        let absentDataStore = FakeDataStore()
        let preferences = StubUserPreferences()
        preferences.refreshStoreOnLaunch = true
        let context = EurofurenceSessionTestBuilder().with(preferences).with(absentDataStore).with(forceUpgradeRequired).build()
        context.sessionStateService.determineSessionState { (_) in }

        XCTAssertTrue(forceUpgradeRequired.wasEnquiredWhetherForceRefreshRequired)
    }

}
