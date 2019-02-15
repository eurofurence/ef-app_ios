//
//  CapturingEventsScheduleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingEventsScheduleDelegate: EventsScheduleDelegate {

    private(set) var events = [EventProtocol]()
    func scheduleEventsDidChange(to events: [EventProtocol]) {
        self.events = events
    }

    private(set) var toldChangedToNilDay = false
    private(set) var capturedCurrentDay: Day?
    func currentEventDayDidChange(to day: Day?) {
        toldChangedToNilDay = day == nil
        capturedCurrentDay = day
    }

    var allDays = [Day]()
    func eventDaysDidChange(to days: [Day]) {
        self.allDays = days
    }

}
