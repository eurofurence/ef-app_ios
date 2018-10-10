//
//  TheFirstTimeSyncFinishes_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class TheFirstTimeSyncFinishes_ApplicationShould: XCTestCase {
    
    func testRestrictEventsToTheFirstConDayWhenRunningBeforeConStarts() {
        let response = APISyncResponse.randomWithoutDeletions
        let firstDay = response.conferenceDays.changed.sorted(by: { $0.date < $1.date }).first!
        let context = ApplicationTestBuilder().with(.distantPast).build()
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        context.performSuccessfulSync(response: response)
        let expectedEvents = response.events.changed.filter({ $0.dayIdentifier == firstDay.identifier })
        let expected = context.makeExpectedEvents(from: expectedEvents, response: response)
        
        XCTAssertEqual(expected, delegate.events)
    }
    
}
