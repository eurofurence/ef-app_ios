public protocol Schedule {

    func loadEvent(identifier: EventIdentifier) -> Event?
    func setDelegate(_ delegate: ScheduleDelegate)
    
    func filterSchedule<S>(to specification: S) where S: Specification, S.Element == Event

}

public protocol ScheduleDelegate {

    func scheduleEventsDidChange(to events: [Event])
    func eventDaysDidChange(to days: [Day])
    func currentEventDayDidChange(to day: Day?)

}
