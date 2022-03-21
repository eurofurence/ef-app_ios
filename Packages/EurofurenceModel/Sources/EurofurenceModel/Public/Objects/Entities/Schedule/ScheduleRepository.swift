import Foundation

public protocol ScheduleRepository {

    func fetchEvent(identifier: EventIdentifier) -> Event?

    func add(_ observer: ScheduleRepositoryObserver)
    func makeEventsSchedule() -> Schedule
    func makeEventsSearchController() -> EventsSearchController

}

public protocol ScheduleRepositoryObserver {

    func eventsDidChange(to events: [Event])
    func runningEventsDidChange(to events: [Event])
    func upcomingEventsDidChange(to events: [Event])
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier])

}
