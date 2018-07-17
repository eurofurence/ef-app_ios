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
        let firstDay = syncResponse.conferenceDays.changed.sorted(by: { $0.date < $1.date }).first!
        schedule = context.application.makeEventsSchedule()
        let expected = syncResponse.events.changed.filter({ $0.dayIdentifier == firstDay.identifier })
        expectedEvents = context.makeExpectedEvents(from: expected, response: syncResponse)
    }
    
    private func performSuccessfulRefresh() {
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
    }
    
    func testUpdateSchedulesWithTheirNewEventsForCurrentDay() {
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        performSuccessfulRefresh()
        
        XCTAssertEqual(expectedEvents, delegate.events)
    }
    
    func testUpdatesLateBoundScheduleDelegatesWithTheirNewEventsForCurrentDay() {
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        performSuccessfulRefresh()
        
        XCTAssertEqual(expectedEvents, delegate.events)
    }
    
}
