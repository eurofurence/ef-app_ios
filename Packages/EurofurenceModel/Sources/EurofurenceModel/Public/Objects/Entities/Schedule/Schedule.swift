public protocol Schedule {

    func fetchEvent(identifier: EventIdentifier) -> Event?
    func setDelegate(_ delegate: ScheduleDelegate)
    func restrictEvents(to day: Day)

}

public protocol ScheduleDelegate {

    func scheduleEventsDidChange(to events: [Event])
    func eventDaysDidChange(to days: [Day])
    func currentEventDayDidChange(to day: Day?)

}
