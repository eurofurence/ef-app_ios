//
//  CalendarServiceTests.swift
//  Eurofurence
//
//  Created by ShezHsky on 05/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol CalendarStore {
    
    func makeEvent() -> CalendarEvent
    func save(event: CalendarEvent)
    func reloadStore()
    
}

protocol CalendarPermissionsProviding {
    
    var isAuthorizedForEventsAccess: Bool { get }
    
    func requestAccessToEvents(completionHandler: (Bool) -> Void)
    
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
    func requestAccessToEvents(completionHandler: (Bool) -> Void) {
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
    func requestAccessToEvents(completionHandler: (Bool) -> Void) {
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
    
    func requestAccessToEvents(completionHandler: (Bool) -> Void) {
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

class CalendarService {

    private let calendarPermissionsProviding: CalendarPermissionsProviding
    private let calendarStore: CalendarStore

    init(calendarPermissionsProviding: CalendarPermissionsProviding, calendarStore: CalendarStore) {
        self.calendarPermissionsProviding = calendarPermissionsProviding
        self.calendarStore = calendarStore
    }

    func add(event: Event) {
        if calendarPermissionsProviding.isAuthorizedForEventsAccess {
            makeAndInsertEvent(event)
        }
        else {
            calendarPermissionsProviding.requestAccessToEvents() { authorized in
                if authorized {
                    makeAndInsertEvent(event)
                }
            }
        }
    }
    
    private func makeAndInsertEvent(_ event: Event) {
        var calendarEvent = calendarStore.makeEvent()
        
        if !calendarEvent.isAssociatedToCalendar {
            calendarStore.reloadStore()
        }

        calendarEvent.title = event.Title
        calendarEvent.notes = event.Description
        calendarEvent.location = event.ConferenceRoom?.Name
        calendarEvent.startDate = event.StartDateTimeUtc
        calendarEvent.endDate = event.EndDateTimeUtc

        let thirtyMinutesPrior: TimeInterval = -1800
        calendarEvent.addAlarm(relativeOffsetFromStartDate: thirtyMinutesPrior)

        calendarStore.save(event: calendarEvent)
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
        let permissions = AuthorizedCalendarPermissionsProviding()
        let calendar = SaveAssertingCalendar(assertion: assertion)
        let service = CalendarService(calendarPermissionsProviding: permissions, calendarStore: calendar)
        service.add(event: event)

        return calendar
    }
    
    func testAddingEventWhenUnauthorizedShouldRequestEventsPermissionsFromTheCalendar() {
        let capturingPermissionsProviding = CapturingCalendarPermissionsProviding()
        capturingPermissionsProviding.isAuthorizedForEventsAccess = false
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: capturingPermissionsProviding, calendarStore: capturingCalendar)
        let event = Event()
        service.add(event: event)

        XCTAssertTrue(capturingPermissionsProviding.wasAskedForEventsPermissions)
    }

    func testEventsPermissionsShouldNotBeRequestedUntilAttemptingToAddEvent() {
        let capturingPermissionsProviding = CapturingCalendarPermissionsProviding()
        let capturingCalendar = CapturingCalendarStore()
        _ = CalendarService(calendarPermissionsProviding: capturingPermissionsProviding, calendarStore: capturingCalendar)

        XCTAssertFalse(capturingPermissionsProviding.wasAskedForEventsPermissions)
    }
    
    func testEventsPermissionsShouldNotBeRequestedWhenAddingEventWhenTheCalendarIndicatesWeAreAlreadyAuthorized() {
        let authorizedPermissions = AuthorizedCalendarPermissionsProviding()
        let service = CalendarService(calendarPermissionsProviding: authorizedPermissions, calendarStore: CapturingCalendarStore())
        let event = Event()
        service.add(event: event)
        
        XCTAssertFalse(authorizedPermissions.wasAskedForEventsPermissions)
    }
    
    func testHavingEventsPermissionsWhenAddingEventShouldRequestCreationOfCalendarEvent() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: AuthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertTrue(capturingCalendar.didMakeEvent)
    }
    
    func testHavingEventsPermissionsWhenAddingEventShouldTellTheCalendarToSaveItsCreatedEvent() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: AuthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
        let event = Event()
        let stubbedCalendarEvent = CalendarEventWithAssociatedCalendar()
        capturingCalendar.createdEvent = stubbedCalendarEvent
        service.add(event: event)
        
        XCTAssertTrue(stubbedCalendarEvent === capturingCalendar.savedEvent as? StubCalendarEvent)
    }
    
    func testNotHavingEventsPermissionsShouldNotMakeEventFromCalendar() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: UnauthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertFalse(capturingCalendar.didMakeEvent)
    }
    
    func testRequestingPermissionWhenAddingEventThenBeingGrantedItShouldMakeTheEvent() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: AuthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertTrue(capturingCalendar.didMakeEvent)
    }
    
    func testRequestingPermissionWhenAddingEventThenBeingDeniedItShouldNotMakeTheEvent() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: UnauthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
        let event = Event()
        service.add(event: event)
        
        XCTAssertFalse(capturingCalendar.didMakeEvent)
    }
    
    func testRequestingPermissionWhenAddingEventThenBeingGrantedItShouldSaveTheCreatedEvent() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: AuthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
        let event = Event()
        let stubbedCalendarEvent = CalendarEventWithAssociatedCalendar()
        capturingCalendar.createdEvent = stubbedCalendarEvent
        service.add(event: event)
        
        XCTAssertTrue(stubbedCalendarEvent === capturingCalendar.savedEvent as? StubCalendarEvent)
    }
    
    func testTheCalendarShouldBeToldToReloadItsStoreWhenTheCreatedEventDoesNotHaveCalendar() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: AuthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
        let event = Event()
        let stubbedCalendarEvent = CalendarEventWithoutAssociatedCalendar()
        capturingCalendar.createdEvent = stubbedCalendarEvent
        service.add(event: event)
        
        XCTAssertTrue(capturingCalendar.didReloadStore)
    }
    
    func testTheCalendarShouldNotBeToldToReloadItsStoreWhenTheCreatedEventDoesHaveCalendar() {
        let capturingCalendar = CapturingCalendarStore()
        let service = CalendarService(calendarPermissionsProviding: AuthorizedCalendarPermissionsProviding(), calendarStore: capturingCalendar)
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
