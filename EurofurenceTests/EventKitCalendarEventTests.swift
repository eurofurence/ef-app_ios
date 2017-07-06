//
//  EventKitCalendarEventTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EventKit
import XCTest

class EventKitCalendarEvent: CalendarEvent {
    
    let event: EKEvent
    
    init(event: EKEvent) {
        self.event = event
    }
    
    var isAssociatedToCalendar: Bool {
        return false
    }
    
    var title: String {
        get {
            return event.title
        }
        set {
            event.title = newValue
        }
    }
    
    var notes: String? {
        get {
            return event.notes
        }
        set {
            event.notes = newValue
        }
    }
    
    var location: String? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    var startDate: Date {
        get {
            return Date()
        }
        set {
            
        }
    }
    
    var endDate: Date {
        get {
            return Date()
        }
        set {
            
        }
    }
    
    func addAlarm(relativeOffsetFromStartDate relativeOffset: TimeInterval) {
        
    }
    
}

class EventKitCalendarEventTests: XCTestCase {
    
    private func makeTestEvent() -> EKEvent {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = "Some Title"
        event.notes = "Some Notes"
        
        return event
    }
    
    func testAccessingTheEventTitleShouldReturnTheTitleFromTheUnderlyingEvent() {
        let event = makeTestEvent()
        let adapter = EventKitCalendarEvent(event: event)
        
        XCTAssertEqual(event.title, adapter.title)
    }
    
    func testSettingTheEventTitleShouldUpdateTheTitleOnTheUnderlyingEvent() {
        let event = makeTestEvent()
        let adapter = EventKitCalendarEvent(event: event)
        let expectedTitle = "Some other title"
        adapter.title = expectedTitle
        
        XCTAssertEqual(expectedTitle, adapter.title)
    }
    
    func testAccessingTheEventNotesShouldReturnTheNotesFromTheUnderlyingEvent() {
        let event = makeTestEvent()
        let adapter = EventKitCalendarEvent(event: event)
        
        XCTAssertEqual(event.notes, adapter.notes)
    }
    
    func testSettingTheEventNotesShouldUpdateTheNotesOnTheUnderlyingEvent() {
        let event = makeTestEvent()
        let adapter = EventKitCalendarEvent(event: event)
        let expectedNotes = "Some other notes"
        adapter.notes = expectedNotes
        
        XCTAssertEqual(expectedNotes, adapter.notes)
    }
    
}
