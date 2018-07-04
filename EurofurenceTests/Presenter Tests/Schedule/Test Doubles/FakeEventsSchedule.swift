//
//  FakeEventsSchedule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeEventsSchedule: EventsSchedule {
    
    var events: [Event2]
    
    init(events: [Event2] = .random) {
        self.events = events
    }
    
    fileprivate var delegate: EventsScheduleDelegate?
    func setDelegate(_ delegate: EventsScheduleDelegate) {
        self.delegate = delegate
        delegate.scheduleEventsDidChange(to: events)
    }
    
    private(set) var dayUsedToRestrictEvents: Day?
    func restrictEvents(to day: Day) {
        dayUsedToRestrictEvents = day
    }
    
}

extension FakeEventsSchedule {
    
    func simulateEventsChanged(_ events: [Event2]) {
        delegate?.scheduleEventsDidChange(to: events)
    }
    
    func simulateDaysChanged(_ days: [Day]) {
        delegate?.eventDaysDidChange(to: days)
    }
    
    func simulateDayChanged(to day: Day?) {
        delegate?.currentEventDayDidChange(to: day)
    }
    
}
