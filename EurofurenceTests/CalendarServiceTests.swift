//
//  CalendarServiceTests.swift
//  Eurofurence
//
//  Created by ShezHsky on 05/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol CalendarPort {

    func requestAccessToEvents()

}

class CapturingCalendarPort: CalendarPort {

    private(set) var wasAskedForEventsPermissions = false
    func requestAccessToEvents() {
        wasAskedForEventsPermissions = true
    }

}

class CalendarService {

    private let calendar: CalendarPort

    init(calendar: CalendarPort) {
        self.calendar = calendar
    }

    func add(event: Any) {
        calendar.requestAccessToEvents()
    }

}

class CalendarServiceTests: XCTestCase {
    
    func testAddingEventShouldRequestEventsPermissionsFromTheCalendar() {
        let capturingCalendar = CapturingCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        service.add(event: event)

        XCTAssertTrue(capturingCalendar.wasAskedForEventsPermissions)
    }

    func testEventsPermissionsShouldNotBeRequestedUntilAttemptingToAddEvent() {
        let capturingCalendar = CapturingCalendarPort()
        _ = CalendarService(calendar: capturingCalendar)

        XCTAssertFalse(capturingCalendar.wasAskedForEventsPermissions)
    }
    
}
