//
//  FakeEventsSchedule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class FakeEventsSchedule: EventsSchedule {

    var events: [EventProtocol]
    var currentDay: Day?

    init(events: [EventProtocol] = [StubEvent].random, currentDay: Day? = .random) {
        self.events = events
        self.currentDay = currentDay
    }

    fileprivate var delegate: EventsScheduleDelegate?
    func setDelegate(_ delegate: EventsScheduleDelegate) {
        self.delegate = delegate
        delegate.scheduleEventsDidChange(to: events)
        delegate.currentEventDayDidChange(to: currentDay)
    }

    private(set) var dayUsedToRestrictEvents: Day?
    func restrictEvents(to day: Day) {
        dayUsedToRestrictEvents = day
    }

}

extension FakeEventsSchedule {

    func simulateEventsChanged(_ events: [EventProtocol]) {
        delegate?.scheduleEventsDidChange(to: events)
    }

    func simulateDaysChanged(_ days: [Day]) {
        delegate?.eventDaysDidChange(to: days)
    }

    func simulateDayChanged(to day: Day?) {
        delegate?.currentEventDayDidChange(to: day)
    }

}
