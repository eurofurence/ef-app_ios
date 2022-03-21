import Foundation

public protocol ScheduleRepository {

    func add(_ observer: ScheduleRepositoryObserver)
    func loadSchedule() -> Schedule
    func makeEventsSearchController() -> EventsSearchController

}

public protocol ScheduleRepositoryObserver {

    func eventsDidChange(to events: [Event])
    func runningEventsDidChange(to events: [Event])
    func upcomingEventsDidChange(to events: [Event])
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier])

}
