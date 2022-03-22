import EurofurenceModel

public class FakeEventsSchedule: Schedule {

    public var events: [Event]
    public var currentDay: Day?

    public init(events: [Event] = [FakeEvent].random, currentDay: Day? = .random) {
        self.events = events
        self.currentDay = currentDay
    }
    
    public func loadEvent(identifier: EventIdentifier) -> Event? {
        events.first(where: { $0.identifier == identifier })
    }

    fileprivate var delegate: ScheduleDelegate?
    public func setDelegate(_ delegate: ScheduleDelegate) {
        self.delegate = delegate
        delegate.scheduleEventsDidChange(to: events)
        delegate.currentEventDayDidChange(to: currentDay)
    }

    public private(set) var dayUsedToRestrictEvents: Day?
    public func restrictEvents(to day: Day) {
        dayUsedToRestrictEvents = day
    }
    
    public func filterSchedule<S>(to specification: S) where S: Specification, S.Element == Event {
        let filteredEvents = events.filter(specification.isSatisfied(by:))
        delegate?.scheduleEventsDidChange(to: filteredEvents)
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
