//
//  WhenResolvingDataStoreState.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenResolvingDataStoreState: XCTestCase {

    func testStoreWithNoLastRefreshTimeIsAbsent() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let context = ApplicationTestBuilder().with(capturingDataStore).build()
        var state: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { state = $0 }

        XCTAssertEqual(.uninitialized, state)
    }

    func testStoreWithLastRefreshDateWithRefreshOnLaunchEnabledIsStale() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { state = $0 }

        XCTAssertEqual(.stale, state)
    }

    func testStoreWithLastRefreshDateWithRefreshOnLaunchDisabledIsAvailable() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }

        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = false
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceSessionState?
        context.sessionStateService.determineSessionState { state = $0 }

        XCTAssertEqual(.initialized, state)
    }

}
