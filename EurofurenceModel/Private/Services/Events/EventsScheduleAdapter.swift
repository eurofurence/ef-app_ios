//
//  EventsScheduleAdapter.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 27/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

private protocol EventFilter {

    func shouldFilter(event: EventCharacteristics) -> Bool

}

extension Day: Comparable {

    public static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }

    public static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }

}

class EventsScheduleAdapter: EventsSchedule {

    private let schedule: ConcreteEventsService
    private let clock: Clock
    private var events = [EurofurenceModel.EventProtocol]()
    private var days = [Day]()
    private var filters = [EventFilter]()
    private var currentDay: Day? {
        didSet {
            delegate?.currentEventDayDidChange(to: currentDay)
        }
    }

    private struct DayRestrictionFilter: EventFilter {

        var day: ConferenceDayCharacteristics

        func shouldFilter(event: EventCharacteristics) -> Bool {
            return event.dayIdentifier == day.identifier
        }

    }

    private class UpdateCurrentDayWhenSignificantTimePasses: EventConsumer {

        private let scheduleAdapter: EventsScheduleAdapter

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }

        func consume(event: DomainEvent.SignificantTimePassedEvent) {
            scheduleAdapter.updateCurrentDay()
        }

    }

    private class UpdateAdapterWhenScheduleChanges: EventConsumer {

        private let scheduleAdapter: EventsScheduleAdapter

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }

        func consume(event: ConcreteEventsService.ChangedEvent) {
            scheduleAdapter.updateFromSchedule()
        }

    }

    init(schedule: ConcreteEventsService, clock: Clock, eventBus: EventBus) {
        self.schedule = schedule
        self.clock = clock
        events = schedule.eventModels
        days = schedule.dayModels

        eventBus.subscribe(consumer: UpdateAdapterWhenScheduleChanges(scheduleAdapter: self))
        eventBus.subscribe(consumer: UpdateCurrentDayWhenSignificantTimePasses(scheduleAdapter: self))
        regenerateSchedule()
        updateCurrentDay()
    }

    private var delegate: EventsScheduleDelegate?
    func setDelegate(_ delegate: EventsScheduleDelegate) {
        self.delegate = delegate

        delegate.scheduleEventsDidChange(to: events)
        updateDelegateWithAllDays()
        delegate.currentEventDayDidChange(to: currentDay)
    }

    func restrictEvents(to day: Day) {
        guard let day = findDay(for: day.date) else { return }
        restrictScheduleToEvents(on: day)
    }

    private func restrictScheduleToEvents(on day: ConferenceDayCharacteristics) {
        if let idx = filters.index(where: { $0 is DayRestrictionFilter }) {
            let filter = filters[idx] as! DayRestrictionFilter
            guard filter.day != day else { return }
            filters.remove(at: idx)
        }

        let filter = DayRestrictionFilter(day: day)
        filters.append(filter)

        regenerateSchedule()
    }

    private func updateCurrentDay() {
        if let day = findDay(for: clock.currentDate) {
            currentDay = Day(date: day.date)
            restrictScheduleToEvents(on: day)
        } else {
            currentDay = nil

            if let firstDay = schedule.days.sorted(by: { $0.date < $1.date }).first {
                restrictScheduleToEvents(on: firstDay)
            }
        }
    }

    private func regenerateSchedule() {
        var allEvents = schedule.events
        filters.forEach { (filter) in
            allEvents = allEvents.filter(filter.shouldFilter)
        }

        events = allEvents.compactMap(schedule.makeEventModel)
        delegate?.scheduleEventsDidChange(to: events)
    }

    private func findDay(for date: Date) -> ConferenceDayCharacteristics? {
        let dateOnlyComponents = resolveDateOnlyComponents(from: date)

        return schedule.days.first { (day) in
            let dayComponents = resolveDateOnlyComponents(from: day.date)
            return dayComponents == dateOnlyComponents
        }
    }

    private func resolveDateOnlyComponents(from date: Date) -> DateComponents {
        let dateCalendarComponents: Set<Calendar.Component> = Set([.day, .month, .year])
        let calendar = Calendar.current
        return calendar.dateComponents(dateCalendarComponents, from: date)
    }

    private func updateDelegateWithAllDays() {
        delegate?.eventDaysDidChange(to: schedule.dayModels)
    }

    private func updateFromSchedule() {
        regenerateSchedule()

        if days != schedule.dayModels {
            self.days = schedule.dayModels
            updateDelegateWithAllDays()
        }

        if filters.contains(where: { $0 is DayRestrictionFilter }) == false {
            updateCurrentDay()
        }
    }

}
