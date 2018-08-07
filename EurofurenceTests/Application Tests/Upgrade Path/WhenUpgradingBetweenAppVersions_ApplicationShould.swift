//
//  WhenUpgradingBetweenAppVersions_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubForceRefreshRequired: ForceRefreshRequired {
    
    var isForceRefreshRequired: Bool
    
}

class CapturingForceRefreshRequired: ForceRefreshRequired {
    
    private(set) var wasEnquiredWhetherForceRefreshRequired = false
    var isForceRefreshRequired: Bool {
        wasEnquiredWhetherForceRefreshRequired = true
        return true
    }
    
}

class WhenUpgradingBetweenAppVersions_ApplicationShould: XCTestCase {
    
    func testIndicateStoreIsStale() {
        let forceUpgradeRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        let presentDataStore = CapturingEurofurenceDataStore()
        presentDataStore.save(.randomWithoutDeletions)
        let context = ApplicationTestBuilder().with(presentDataStore).with(forceUpgradeRequired).build()
        var dataStoreState: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { dataStoreState = $0 }
        
        XCTAssertEqual(EurofurenceDataStoreState.stale, dataStoreState)
    }
    
    func testAlwaysEnquireWhetherUpgradeRequiredEvenWhenRefreshWouldOccurByPreference() {
        let forceUpgradeRequired = CapturingForceRefreshRequired()
        let presentDataStore = CapturingEurofurenceDataStore()
        presentDataStore.save(.randomWithoutDeletions)
        let preferences = StubUserPreferences()
        preferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(preferences).with(presentDataStore).with(forceUpgradeRequired).build()
        context.application.resolveDataStoreState { (_) in }
        
        XCTAssertTrue(forceUpgradeRequired.wasEnquiredWhetherForceRefreshRequired)
    }
    
}
