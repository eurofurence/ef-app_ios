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
            
        }
    }
    
    var notes: String {
        get {
            return ""
        }
        set {
            
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
    
    func addAlarm(relativeOffsetFromStartDate relativeOffset: TimeInterval){
        
    }
    
}

class EventKitCalendarEventTests: XCTestCase {
    
    func testAccessingTheEventTitleShouldReturnTheTitleFromTheUnderlyingEvent() {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = "Some Title"
        let adapter = EventKitCalendarEvent(event: event)
        
        XCTAssertEqual(event.title, adapter.title)
    }
    
}
