//
//  WhenResolvingDataStoreState.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResolvingDataStoreState: XCTestCase {

    func testStoreWithNoLastRefreshTimeIsAbsent() {
        let capturingDataStore = FakeDataStore()
        let context = EurofurenceSessionTestBuilder().with(capturingDataStore).build()
        var state: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { state = $0 }

        XCTAssertEqual(.uninitialized, state)
    }

    func testStoreWithLastRefreshDateWithRefreshOnLaunchEnabledIsStale() {
        let capturingDataStore = FakeDataStore()
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
        let capturingDataStore = FakeDataStore()
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
