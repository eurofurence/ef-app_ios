//
//  WhenSyncCompletesWithConferenceDays_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSyncCompletesWithConferenceDays_ApplicationShould: XCTestCase {
    
    func testProvideTheAdaptedDaysToObserversInDateOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expected = context.makeExpectedDays(from: syncResponse)
        
        XCTAssertEqual(expected, observer.allDays)
    }
    
    func testProvideLateAddedObserversWithAdaptedDays() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        let expected = context.makeExpectedDays(from: syncResponse)
        
        XCTAssertEqual(expected, observer.allDays)
    }
    
    func testSaveTheConferenceDaysToTheDataStore() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertTrue(context.dataStore.didSave(syncResponse.conferenceDays.changed))
    }
    
}
