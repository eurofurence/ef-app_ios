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

    func requestAccessToEvents(completionHandler: (Bool) -> Void)
    func makeEvent() -> CalendarEvent
    func save(event: CalendarEvent)
    func reloadStore()

}

protocol CalendarEvent {
    
    var isAssociatedToCalendar: Bool { get }
    
}

class CapturingCalendarPort: CalendarPort {
    
    var isAuthorizedForEventsAccess: Bool {
        get {
            return false
        }
    }

    private(set) var wasAskedForEventsPermissions = false
    func requestAccessToEvents(completionHandler: (Bool) -> Void) {
        wasAskedForEventsPermissions = true
    }
    
    private(set) var didMakeEvent = false
    var createdEvent: CalendarEvent = CalendarEventWithAssociatedCalendar()
    func makeEvent() -> CalendarEvent {
        didMakeEvent = true
        return createdEvent
    }
    
    private(set) var savedEvent: CalendarEvent?
    func save(event: CalendarEvent) {
        savedEvent = event
    }
    
    private(set) var didReloadStore = false
    func reloadStore() {
        didReloadStore = true
    }

}

class StubCalendarEvent: CalendarEvent {
    
    init(associatedToCalendar: Bool) {
        isAssociatedToCalendar = associatedToCalendar
    }
    
    private(set) var isAssociatedToCalendar: Bool
    
}

class CalendarEventWithAssociatedCalendar: StubCalendarEvent {
    
    convenience init() {
        self.init(associatedToCalendar: true)
    }
    
}

class CalendarEventWithoutAssociatedCalendar: StubCalendarEvent {
    
    convenience init() {
        self.init(associatedToCalendar: false)
    }
    
}

class AuthorizedCalendarPort: CapturingCalendarPort {
    
    override var isAuthorizedForEventsAccess: Bool {
        get {
            return true
        }
    }
    
}

class UnauthorizedCalendarPort: CapturingCalendarPort {
    
    override var isAuthorizedForEventsAccess: Bool {
        get {
            return false
        }
    }
    
}

class PermissionGrantingCalendarPort: CapturingCalendarPort {
    
    override func requestAccessToEvents(completionHandler: (Bool) -> Void) {
        super.requestAccessToEvents(completionHandler: completionHandler)
        completionHandler(true)
    }
    
}

class PermissionDenyingCalendarPort: CapturingCalendarPort {
    
    override func requestAccessToEvents(completionHandler: (Bool) -> Void) {
        super.requestAccessToEvents(completionHandler: completionHandler)
        completionHandler(false)
    }
    
}

class CalendarService {

    private let calendar: CalendarPort

    init(calendar: CalendarPort) {
        self.calendar = calendar
    }

    func add(event: Any) {
        if calendar.isAuthorizedForEventsAccess {
            makeAndInsertEvent(event)
        }
        else {
            calendar.requestAccessToEvents() { authorized in
                if authorized {
                    makeAndInsertEvent(event)
                }
            }
        }
    }
    
    private func makeAndInsertEvent(_ event: Any) {
        let calendarEvent = calendar.makeEvent()
        
        if !calendarEvent.isAssociatedToCalendar {
            calendar.reloadStore()
        }
        
        calendar.save(event: calendarEvent)
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
    
    func testHavingEventsPermissionsWhenAddingEventShouldRequestCreationOfCalendarEvent() {
        let capturingCalendar = AuthorizedCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertTrue(capturingCalendar.didMakeEvent)
    }
    
    func testHavingEventsPermissionsWhenAddingEventShouldTellTheCalendarToSaveItsCreatedEvent() {
        let capturingCalendar = AuthorizedCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        let stubbedCalendarEvent = CalendarEventWithAssociatedCalendar()
        capturingCalendar.createdEvent = stubbedCalendarEvent
        service.add(event: event)
        
        XCTAssertTrue(stubbedCalendarEvent === capturingCalendar.savedEvent as? StubCalendarEvent)
    }
    
    func testNotHavingEventsPermissionsShouldNotMakeEventFromCalendar() {
        let capturingCalendar = UnauthorizedCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertFalse(capturingCalendar.didMakeEvent)
    }
    
    func testRequestingPermissionWhenAddingEventThenBeingGrantedItShouldMakeTheEvent() {
        let capturingCalendar = PermissionGrantingCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertTrue(capturingCalendar.didMakeEvent)
    }
    
    func testRequestingPermissionWhenAddingEventThenBeingDeniedItShouldNotMakeTheEvent() {
        let capturingCalendar = PermissionDenyingCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertFalse(capturingCalendar.didMakeEvent)
    }
    
    func testRequestingPermissionWhenAddingEventThenBeingGrantedItShouldSaveTheCreatedEvent() {
        let capturingCalendar = PermissionGrantingCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        let stubbedCalendarEvent = CalendarEventWithAssociatedCalendar()
        capturingCalendar.createdEvent = stubbedCalendarEvent
        service.add(event: event)
        
        XCTAssertTrue(stubbedCalendarEvent === capturingCalendar.savedEvent as? StubCalendarEvent)
    }
    
    func testTheCalendarShouldBeToldToReloadItsStoreWhenTheCreatedEventDoesNotHaveCalendar() {
        let capturingCalendar = AuthorizedCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        let stubbedCalendarEvent = CalendarEventWithoutAssociatedCalendar()
        capturingCalendar.createdEvent = stubbedCalendarEvent
        service.add(event: event)
        
        XCTAssertTrue(capturingCalendar.didReloadStore)
    }
    
    func testTheCalendarShouldNotBeToldToReloadItsStoreWhenTheCreatedEventDoesHaveCalendar() {
        let capturingCalendar = AuthorizedCalendarPort()
        let service = CalendarService(calendar: capturingCalendar)
        let event = Event()
        let stubbedCalendarEvent = CalendarEventWithAssociatedCalendar()
        capturingCalendar.createdEvent = stubbedCalendarEvent
        service.add(event: event)
        
        XCTAssertFalse(capturingCalendar.didReloadStore)
    }
    
}
