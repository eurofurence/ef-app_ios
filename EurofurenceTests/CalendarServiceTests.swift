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
    
    var isAuthorizedForEventsAccess: Bool { get }

    func requestAccessToEvents()

}

class CapturingCalendarPort: CalendarPort {
    
    var isAuthorizedForEventsAccess: Bool {
        get {
            return false
        }
    }

    private(set) var wasAskedForEventsPermissions = false
    func requestAccessToEvents() {
        wasAskedForEventsPermissions = true
    }

}

class AuthorizedCalendarPort: CapturingCalendarPort {
    
    override var isAuthorizedForEventsAccess: Bool {
        get {
            return true
        }
    }
    
}

class CalendarService {

    private let calendar: CalendarPort

    init(calendar: CalendarPort) {
        self.calendar = calendar
    }

    func add(event: Any) {
        if !calendar.isAuthorizedForEventsAccess {
            calendar.requestAccessToEvents()
        }
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
    
    func testEventsPermissionsShouldNotBeRequestedWhenAddingEventWhenTheCalendarIndicatesWeAreAlreadyAuthorized() {
        let capturingCalendar = AuthorizedCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertFalse(capturingCalendar.wasAskedForEventsPermissions)
    }
    
}
