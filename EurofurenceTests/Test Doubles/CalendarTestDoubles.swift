//
//  CalendarTestDoubles.swift
//  Eurofurence
//
//  Created by ShezHsky on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingCalendarStore: CalendarStore {
    
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

class CapturingCalendarPermissionsProviding: CalendarPermissionsProviding {
    
    var isAuthorizedForEventsAccess: Bool = true
    
    private(set) var wasAskedForEventsPermissions = false
    func requestAccessToEvents(completionHandler: @escaping (Bool) -> Void) {
        wasAskedForEventsPermissions = true
    }
    
}

class StubCalendarEvent: CalendarEvent {
    
    init(associatedToCalendar: Bool) {
        isAssociatedToCalendar = associatedToCalendar
    }
    
    private(set) var isAssociatedToCalendar: Bool
    var title: String = ""
    var notes: String = ""
    var location: String?
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    private(set) var addedRelativeAlarmTime: TimeInterval?
    func addAlarm(relativeOffsetFromStartDate relativeOffset: TimeInterval) {
        addedRelativeAlarmTime = relativeOffset
    }
    
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

class AuthorizedCalendarPermissionsProviding: CalendarPermissionsProviding {
    
    var isAuthorizedForEventsAccess: Bool {
        get {
            return true
        }
    }
    
    private(set) var wasAskedForEventsPermissions = false
    func requestAccessToEvents(completionHandler: @escaping (Bool) -> Void) {
        wasAskedForEventsPermissions = true
        completionHandler(true)
    }
    
}

class UnauthorizedCalendarPermissionsProviding: CalendarPermissionsProviding {
    
    var isAuthorizedForEventsAccess: Bool {
        get {
            return false
        }
    }
    
    func requestAccessToEvents(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(false)
    }
    
}

class SaveAssertingCalendar: CalendarStore {
    
    private let assertion: (CalendarEvent) -> Bool
    private(set) var isSatisfied = false
    
    init(assertion: @escaping (CalendarEvent) -> Bool) {
        self.assertion = assertion
    }
    
    func makeEvent() -> CalendarEvent {
        return StubCalendarEvent(associatedToCalendar: true)
    }
    
    func save(event: CalendarEvent) {
        isSatisfied = assertion(event)
    }
    
    func reloadStore() { }
    
}

class MultipleEventCreationCalendarStore: CalendarStore {
    
    var events: [CalendarEvent]
    
    init(events: [CalendarEvent]) {
        self.events = events
    }
    
    func makeEvent() -> CalendarEvent {
        return events.removeFirst()
    }
    
    private(set) var savedEvent: CalendarEvent?
    func save(event: CalendarEvent) {
        savedEvent = event
    }
    
    func reloadStore() { }
    
}
