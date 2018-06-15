//
//  WhenSyncCompletesWithEvents_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingEventsScheduleDelegate: EventsScheduleDelegate {
    
    private(set) var events = [Event2]()
    func eventsDidChange(to events: [Event2]) {
        self.events = events
    }
    
}

class WhenSyncCompletesWithEvents_ApplicationShould: XCTestCase {
    
    func testTellObserversAboutAvailableEvents() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expected = context.makeExpectedEvents(from: syncResponse.events.changed, response: syncResponse)

        XCTAssertEqual(expected, observer.allEvents)
    }
    
    func testUpdateSchedulesWithTheirNewEvents() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let observer = CapturingEventsServiceObserver()
        context.application.add(observer)
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expected = context.makeExpectedEvents(from: syncResponse.events.changed, response: syncResponse)
        
        XCTAssertEqual(expected, delegate.events)
    }
    
}
