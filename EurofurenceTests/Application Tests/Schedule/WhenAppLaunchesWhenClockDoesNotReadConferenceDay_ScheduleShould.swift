//
//  WhenAppLaunchesWhenClockDoesNotReadConferenceDay_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAppLaunchesWhenClockDoesNotReadConferenceDay_ScheduleShould: XCTestCase {
    
    func testChangeToNilConDay() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(.distantPast).with(dataStore).build()
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        
        XCTAssertTrue(delegate.toldChangedToNilDay)
    }
    
}
