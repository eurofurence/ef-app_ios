import EurofurenceModel

public class FakeEventsSchedule: EventsSchedule {

    public var events: [Event]
    public var currentDay: Day?

    public init(events: [Event] = [FakeEvent].random, currentDay: Day? = .random) {
        self.events = events
        self.currentDay = currentDay
    }

    fileprivate var delegate: EventsScheduleDelegate?
    public func setDelegate(_ delegate: EventsScheduleDelegate) {
        self.delegate = delegate
        delegate.scheduleEventsDidChange(to: events)
        delegate.currentEventDayDidChange(to: currentDay)
    }

    public private(set) var dayUsedToRestrictEvents: Day?
    public func restrictEvents(to day: Day) {
        dayUsedToRestrictEvents = day
    }

}

extension FakeEventsSchedule {

    public func simulateEventsChanged(_ events: [Event]) {
        delegate?.scheduleEventsDidChange(to: events)
    }

    public func simulateDaysChanged(_ days: [Day]) {
        delegate?.eventDaysDidChange(to: days)
    }

    public func simulateDayChanged(to day: Day?) {
        delegate?.currentEventDayDidChange(to: day)
    }

}
