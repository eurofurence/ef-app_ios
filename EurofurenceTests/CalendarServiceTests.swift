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

    var title: String { get set }
    var notes: String { get set }
    var location: String? { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }

    func addAlarm(relativeOffsetFromStartDate relativeOffset: TimeInterval)
    
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

class SaveAssertingCalendar: AuthorizedCalendarPort {

    private let assertion: (CalendarEvent) -> Bool
    private(set) var isSatisfied = false

    init(assertion: @escaping (CalendarEvent) -> Bool) {
        self.assertion = assertion
    }

    override func save(event: CalendarEvent) {
        super.save(event: event)
        isSatisfied = assertion(event)
    }

}

class CalendarService {

    private let calendar: CalendarPort

    init(calendar: CalendarPort) {
        self.calendar = calendar
    }

    func add(event: Event) {
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
    
    private func makeAndInsertEvent(_ event: Event) {
        var calendarEvent = calendar.makeEvent()
        
        if !calendarEvent.isAssociatedToCalendar {
            calendar.reloadStore()
        }

        calendarEvent.title = event.Title
        calendarEvent.notes = event.Description
        calendarEvent.location = event.ConferenceRoom?.Name
        calendarEvent.startDate = event.StartDateTimeUtc
        calendarEvent.endDate = event.EndDateTimeUtc

        let thirtyMinutesPrior: TimeInterval = -1800
        calendarEvent.addAlarm(relativeOffsetFromStartDate: thirtyMinutesPrior)

        calendar.save(event: calendarEvent)
    }

}

class CalendarServiceTests: XCTestCase {

    private func makeEventWithValues() -> Event {
        let event = Event()
        event.Title = "Title"
        event.Description = "Notes"
        event.StartDateTimeUtc = .distantPast
        event.EndDateTimeUtc = .distantFuture

        let room = EventConferenceRoom()
        room.Name = "Some Room"
        event.ConferenceRoom = room

        return event
    }

    private func makeCalendarEventCreationTest(event: Event,
                                               assertion: @escaping (CalendarEvent) -> Bool) -> SaveAssertingCalendar {
        let eventAssertion = SaveAssertingCalendar(assertion: assertion)
        let service = CalendarService(calendar: eventAssertion)
        let stubbedCalendarEvent = CalendarEventWithAssociatedCalendar()
        eventAssertion.createdEvent = stubbedCalendarEvent
        service.add(event: event)

        return eventAssertion
    }
    
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

    func testTheTitleFromTheEventShouldBeSetOntoTheCalendarEvent() {
        let event = makeEventWithValues()
        let eventAssertion = makeCalendarEventCreationTest(event: event,
                                                           assertion: { $0.title == event.Title })

        XCTAssertTrue(eventAssertion.isSatisfied)
    }

    func testTheNotesFromTheEventShouldBeSetOntoTheCalendarEvent() {
        let event = makeEventWithValues()
        let eventAssertion = makeCalendarEventCreationTest(event: event,
                                                           assertion: { $0.notes == event.Description })

        XCTAssertTrue(eventAssertion.isSatisfied)
    }

    func testTheLocationFromTheEventShouldBeSetOntoTheCalendarEvent() {
        let event = makeEventWithValues()
        let eventAssertion = makeCalendarEventCreationTest(event: event,
                                                           assertion: { $0.location == event.ConferenceRoom?.Name })

        XCTAssertTrue(eventAssertion.isSatisfied)
    }

    func testTheStartDateFromTheEventShouldBeSetOntoTheCalendarEvent() {
        let event = makeEventWithValues()
        let eventAssertion = makeCalendarEventCreationTest(event: event,
                                                           assertion: { $0.startDate == event.StartDateTimeUtc })

        XCTAssertTrue(eventAssertion.isSatisfied)
    }

    func testTheEndDateFromTheEventShouldBeSetOntoTheCalendarEvent() {
        let event = makeEventWithValues()
        let eventAssertion = makeCalendarEventCreationTest(event: event,
                                                           assertion: { $0.endDate == event.EndDateTimeUtc })

        XCTAssertTrue(eventAssertion.isSatisfied)
    }

    func testTheEventIsGivenAnAlarmWithHalfAnHourPriorToTheStartTime() {
        let event = makeEventWithValues()
        let expectedRelativeOffsetFromStartTime: TimeInterval = -1800
        let assertion: (CalendarEvent) -> Bool = { event in
            return (event as? StubCalendarEvent)?.addedRelativeAlarmTime == expectedRelativeOffsetFromStartTime
        }

        let eventAssertion = makeCalendarEventCreationTest(event: event,
                                                           assertion: assertion)

        XCTAssertTrue(eventAssertion.isSatisfied)
    }
    
}
