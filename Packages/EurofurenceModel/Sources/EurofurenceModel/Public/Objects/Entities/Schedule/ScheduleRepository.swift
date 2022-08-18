import Foundation

public protocol ScheduleRepository {

    func add(_ observer: ScheduleRepositoryObserver)
    
    /// Loads a `Schedule` for use in event resolution and filtering.
    /// - Parameter tag: A description for the usage of the `Schedule` for debugging.
    /// - Returns: A tagged `Schedule` with no specifications set.
    func loadSchedule(tag: String) -> Schedule

}

public protocol ScheduleRepositoryObserver: AnyObject {

    func eventsDidChange(to events: [Event])
    func runningEventsDidChange(to events: [Event])
    func upcomingEventsDidChange(to events: [Event])
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier])

}
