public protocol Schedule {

    func setDelegate(_ delegate: ScheduleDelegate)
    func restrictEvents(to day: Day)

}

public protocol ScheduleDelegate {

    func scheduleEventsDidChange(to events: [Event])
    func eventDaysDidChange(to days: [Day])
    func currentEventDayDidChange(to day: Day?)

}
