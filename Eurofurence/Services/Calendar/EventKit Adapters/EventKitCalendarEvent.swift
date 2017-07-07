//
//  EventKitCalendarEvent.swift
//  Eurofurence
//
//  Created by ShezHsky on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EventKit
import Foundation

class EventKitCalendarEvent: CalendarEvent {

    let event: EKEvent

    init(event: EKEvent) {
        self.event = event
    }

    var isAssociatedToCalendar: Bool {
        let calendar: EKCalendar? = event.calendar
        return calendar != nil
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
            return event.location
        }
        set {
            event.location = newValue
        }
    }

    var startDate: Date {
        get {
            return event.startDate
        }
        set {
            event.startDate = newValue
        }
    }

    var endDate: Date {
        get {
            return event.endDate
        }
        set {
            event.endDate = newValue
        }
    }

    func addAlarm(relativeOffsetFromStartDate relativeOffset: TimeInterval) {
        let alarm = EKAlarm(relativeOffset: relativeOffset)
        event.addAlarm(alarm)
    }

}
