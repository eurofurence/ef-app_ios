//
//  CalendarServiceTests.swift
//  Eurofurence
//
//  Created by ShezHsky on 05/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

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
