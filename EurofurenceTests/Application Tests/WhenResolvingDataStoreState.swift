//
//  WhenResolvingDataStoreState.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingEurofurenceDataStore: EurofurenceDataStore {
    
    private(set) var capturedResolveContentsStateHandler: ((EurofurenceDataStoreContentsState) -> Void)?
    func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void) {
        capturedResolveContentsStateHandler = completionHandler
    }
    
}

class StubUserPreferences: UserPreferences {
    
    var refreshStoreOnLaunch = false
    
}

class WhenResolvingDataStoreState: XCTestCase {
    
    func testEmptyStateStoreProvidesAbsentStore() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let context = ApplicationTestBuilder().with(capturingDataStore).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.empty)
        
        XCTAssertEqual(.absent, state)
    }
    
    func testNonEmptyStoreWhenUserRequestedRefreshOnLaunchReturnsStale() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.present)
        
        XCTAssertEqual(.stale, state)
    }
    
    func testEmptyDataStoreWhenUserRequestedRefreshOnLaunchReturnsAbsent() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.empty)
        
        XCTAssertEqual(.absent, state)
    }
    
    func testNonEmptyStoreWhenUserDidNotRequestRefreshOnLaunchReturnsAvailable() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = false
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.present)
        
        XCTAssertEqual(.available, state)
    }
    
    func testResolutionHandlerNotInvokedBeforeDataStoreResolvesContentsState() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        
        XCTAssertNil(state)
    }
    
}
