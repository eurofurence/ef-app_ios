import Foundation

private protocol EventFilter {

    func shouldFilter(event: EventImpl) -> Bool

}

extension Day: Comparable {

    public static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }

    public static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }

}

class EventsScheduleAdapter: Schedule {

    private let schedule: ConcreteScheduleRepository
    private let clock: Clock
    private var events = [EurofurenceModel.Event]()
    private var days = [Day]()
    private var filters = [EventFilter]()
    private var currentDay: Day? {
        didSet {
            delegate?.currentEventDayDidChange(to: currentDay)
        }
    }

    private struct DayRestrictionFilter: EventFilter {

        var day: ConferenceDayCharacteristics

        func shouldFilter(event: EventImpl) -> Bool {
            return event.day.identifier == day.identifier
        }

    }

    private struct UpdateCurrentDayWhenSignificantTimePasses: EventConsumer {

        private unowned let scheduleAdapter: EventsScheduleAdapter

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }

        func consume(event: DomainEvent.SignificantTimePassedEvent) {
            scheduleAdapter.updateCurrentDay()
        }

    }

    private struct UpdateAdapterWhenScheduleChanges: EventConsumer {

        private unowned let scheduleAdapter: EventsScheduleAdapter

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }

        func consume(event: DomainEvent.EventsChanged) {
            scheduleAdapter.updateFromSchedule()
        }

    }

    init(schedule: ConcreteScheduleRepository, clock: Clock, eventBus: EventBus) {
        self.schedule = schedule
        self.clock = clock
        events = schedule.eventModels
        days = schedule.dayModels

        eventBus.subscribe(consumer: UpdateAdapterWhenScheduleChanges(scheduleAdapter: self))
        eventBus.subscribe(consumer: UpdateCurrentDayWhenSignificantTimePasses(scheduleAdapter: self))
        regenerateSchedule()
        updateCurrentDay()
    }
    
    func loadEvent(identifier: EventIdentifier) -> Event? {
        schedule.eventModels.first(where: { $0.identifier == identifier })
    }

    private var delegate: ScheduleDelegate?
    func setDelegate(_ delegate: ScheduleDelegate) {
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
        if let idx = filters.firstIndex(where: { $0 is DayRestrictionFilter }) {
            guard let filter = filters[idx] as? DayRestrictionFilter else { return }
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

            if let firstDay = schedule.days.min(by: { $0.date < $1.date }) {
                restrictScheduleToEvents(on: firstDay)
            }
        }
    }

    private func regenerateSchedule() {
        var allEvents = schedule.eventModels
        filters.forEach { (filter) in
            allEvents = allEvents.filter(filter.shouldFilter)
        }

        events = allEvents.sorted(by: { $0.startDate < $1.startDate })
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
