//
//  CalendarServiceTests.swift
//  Eurofurence
//
//  Created by ShezHsky on 05/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol Calendar {

    func requestAccessToEvents()

}

class CapturingCalendar: Calendar {

    private(set) var wasAskedForEventsPermissions = false
    func requestAccessToEvents() {
        wasAskedForEventsPermissions = true
    }

}

class CalendarService {

    private let calendar: Calendar

    init(calendar: Calendar) {
        self.calendar = calendar
    }

    func add(event: Any) {
        calendar.requestAccessToEvents()
    }

}

class CalendarServiceTests: XCTestCase {
    
    func testAddingEventShouldRequestEventsPermissionsFromTheCalendar() {
        let capturingCalendar = CapturingCalendar()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        service.add(event: event)

        XCTAssertTrue(capturingCalendar.wasAskedForEventsPermissions)
    }

    func testEventsPermissionsShouldNotBeRequestedUntilAttemptingToAddEvent() {
        let capturingCalendar = CapturingCalendar()
        _ = CalendarService(calendar: capturingCalendar)

        XCTAssertFalse(capturingCalendar.wasAskedForEventsPermissions)
    }
    
}
