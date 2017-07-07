//
//  EventKitCalendarEventTests.swift
//  Eurofurence
//
//  Created by ShezHsky on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EventKit
import XCTest

class EventKitCalendarEventTests: XCTestCase {
    
    var eventStore: EKEventStore!
    var event: EKEvent!
    var adapter: EventKitCalendarEvent!
    
    override func setUp() {
        super.setUp()
        
        eventStore = EKEventStore()
        event = EKEvent(eventStore: eventStore)
        event.title = "Some Title"
        event.notes = "Some Notes"
        event.location = "Some Location"
        event.startDate = .distantPast
        event.endDate = .distantFuture
        
        adapter = EventKitCalendarEvent(event: event)
    }
    
    func testTheEventShouldBeAssociatedToCalendarIfItHasOne() {
        event.calendar = EKCalendar(for: .event, eventStore: eventStore)
        
        XCTAssertTrue(adapter.isAssociatedToCalendar)
    }
    
    func testTheEventShouldNotBeAssociatedToCalendarIfItDoesNotHaveOne() {
        XCTAssertFalse(adapter.isAssociatedToCalendar)
    }
    
    func testAccessingTheEventTitleShouldReturnTheTitleFromTheUnderlyingEvent() {
        XCTAssertEqual(event.title, adapter.title)
    }
    
    func testSettingTheEventTitleShouldUpdateTheTitleOnTheUnderlyingEvent() {
        let expectedTitle = "Some other title"
        adapter.title = expectedTitle
        
        XCTAssertEqual(expectedTitle, event.title)
    }
    
    func testAccessingTheEventNotesShouldReturnTheNotesFromTheUnderlyingEvent() {
        XCTAssertEqual(event.notes, adapter.notes)
    }
    
    func testSettingTheEventNotesShouldUpdateTheNotesOnTheUnderlyingEvent() {
        let expectedNotes = "Some other notes"
        adapter.notes = expectedNotes
        
        XCTAssertEqual(expectedNotes, event.notes)
    }
    
    func testAccessingTheEventLocationShouldReturnTheLocationFromTheUnderlyingEvent() {
        XCTAssertEqual(event.location, adapter.location)
    }
    
    func testSettingTheEventLocationShouldUpdateTheLocationOnTheUnderlyingEvent() {
        let expectedLocation = "Some other location"
        adapter.location = expectedLocation
        
        XCTAssertEqual(expectedLocation, event.location)
    }
    
    func testAccessingTheEventStartDateShouldReturnTheStartDateFromTheUnderlyingEvent() {
        XCTAssertEqual(event.startDate, adapter.startDate)
    }
    
    func testSettingTheEventStartDateShouldUpdateTheStartDateOnTheUnderlyingEvent() {
        let expectedStartDate = Date(timeIntervalSinceReferenceDate: 1000)
        adapter.startDate = expectedStartDate
        
        XCTAssertEqual(expectedStartDate, event.startDate)
    }
    
    func testAccessingTheEventEndDateShouldReturnTheEndDateFromTheUnderlyingEvent() {
        XCTAssertEqual(event.endDate, adapter.endDate)
    }
    
    func testSettingTheEventEndDateShouldUpdateTheEndDateOnTheUnderlyingEvent() {
        let expectedEndDate = Date(timeIntervalSinceReferenceDate: 1000)
        adapter.endDate = expectedEndDate
        
        XCTAssertEqual(expectedEndDate, event.endDate)
    }
    
    func testAddingAnAlarmShouldAddTheAlarmToTheUnderlyingEvent() {
        let relativeOffset: TimeInterval = 100
        adapter.addAlarm(relativeOffsetFromStartDate: relativeOffset)
        
        XCTAssertEqual(relativeOffset, event.alarms?.first?.relativeOffset)
    }
    
}
