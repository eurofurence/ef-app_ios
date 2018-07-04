//
//  CapturingEventsScheduleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingEventsScheduleDelegate: EventsScheduleDelegate {
    
    private(set) var events = [Event2]()
    func scheduleEventsDidChange(to events: [Event2]) {
        self.events = events
    }
    
    private(set) var toldChangedToNilDay = false
    private(set) var capturedCurrentDay: Day?
    func currentEventDayDidChange(to day: Day?) {
        toldChangedToNilDay = day == nil
        capturedCurrentDay = day
    }
    
    private(set) var allDays = [Day]()
    func eventDaysDidChange(to days: [Day]) {
        self.allDays = days
    }
    
}
