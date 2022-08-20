import EurofurenceModel

public class FakeEventsSchedule: Schedule {

    public var events: [Event]
    public var currentDay: Day?
    
    private let originalEvents: [Event]

    public init(events: [Event] = [FakeEvent].random, currentDay: Day? = .random) {
        self.events = events
        self.originalEvents = events
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
    
    public private(set) var specification: AnySpecification<Event>?
    public func filterSchedule<S>(to specification: S) where S: Specification, S.Element == Event {
        let erasedSpecification = specification.eraseToAnySpecification()
        self.specification = erasedSpecification
        
        events = events.filter(specification.isSatisfied(by:))
        delegate?.scheduleEventsDidChange(to: events)
        delegate?.scheduleSpecificationChanged(to: erasedSpecification)
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
        currentDay = day
        delegate?.currentEventDayDidChange(to: day)
    }

}
