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
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.application.makeEventsSchedule()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)
        let expected = context.makeExpectedDays(from: syncResponse)
        
        XCTAssertEqual(expected, delegate.allDays)
    }
    
    func testProvideLateAddedObserversWithAdaptedDays() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.application.makeEventsSchedule()
        schedule.setDelegate(delegate)
        let expected = context.makeExpectedDays(from: syncResponse)
        
        XCTAssertEqual(expected, delegate.allDays)
    }
    
    func testSaveTheConferenceDaysToTheDataStore() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        
        XCTAssertTrue(context.dataStore.didSave(syncResponse.conferenceDays.changed))
    }
    
}
