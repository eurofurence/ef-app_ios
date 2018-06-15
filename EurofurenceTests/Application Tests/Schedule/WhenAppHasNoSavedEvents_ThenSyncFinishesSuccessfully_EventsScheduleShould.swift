//
//  WhenAppHasNoSavedEvents_ThenSyncFinishesSuccessfully_EventsScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAppHasNoSavedEvents_ThenSyncFinishesSuccessfully_EventsScheduleShould: XCTestCase {
    
    var context: ApplicationTestBuilder.Context!
    var syncResponse: APISyncResponse!
    var schedule: EventsSchedule!
    var expectedEvents: [Event2]!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationTestBuilder().build()
        syncResponse = APISyncResponse.randomWithoutDeletions
        schedule = context.application.makeEventsSchedule()
        expectedEvents = context.makeExpectedEvents(from: syncResponse.events.changed, response: syncResponse)
    }
    
    private func performSuccessfulRefresh() {
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
    }
    
    func testUpdateSchedulesWithTheirNewEvents() {
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        performSuccessfulRefresh()
        
        XCTAssertEqual(expectedEvents, delegate.events)
    }
    
    func testUpdatesLateBoundScheduleDelegatesWithTheirNewEvents() {
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        performSuccessfulRefresh()
        
        XCTAssertEqual(expectedEvents, delegate.events)
    }
    
}
