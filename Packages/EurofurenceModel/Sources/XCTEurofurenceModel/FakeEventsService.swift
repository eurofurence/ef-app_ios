import EurofurenceModel
import Foundation

public class FakeScheduleRepository: ScheduleRepository {

    public var runningEvents: [Event] = []
    public var upcomingEvents: [Event] = []
    public var allEvents: [Event] = []
    public var favourites: [EventIdentifier] = []

    public init(favourites: [EventIdentifier] = []) {
        self.favourites = favourites
    }

    private var observers = [ScheduleRepositoryObserver]()
    public func add(_ observer: ScheduleRepositoryObserver) {
        observers.append(observer)

        observer.eventsDidChange(to: allEvents)
        observer.runningEventsDidChange(to: runningEvents)
        observer.upcomingEventsDidChange(to: upcomingEvents)
        observer.favouriteEventsDidChange(favourites)
    }

    public private(set) var lastProducedSchedule: FakeEventsSchedule?
    public func makeEventsSchedule() -> Schedule {
        let schedule = FakeEventsSchedule(events: allEvents)
        lastProducedSchedule = schedule
        return schedule
    }

    public private(set) var lastProducedSearchController: FakeEventsSearchController?
    public func makeEventsSearchController() -> EventsSearchController {
        let searchController = FakeEventsSearchController()
        lastProducedSearchController = searchController
        return searchController
    }

}

extension FakeScheduleRepository {

    public func stubSomeFavouriteEvents() {
        allEvents = [FakeEvent].random(minimum: 3)
        favourites = Array(allEvents.dropFirst()).map(\.identifier)
    }

    public func simulateEventFavourited(identifier: EventIdentifier) {
        favourites.append(identifier)
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    public func simulateEventFavouritesChanged(to identifiers: [EventIdentifier]) {
        favourites = identifiers
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    public func simulateEventUnfavourited(identifier: EventIdentifier) {
        if let idx = favourites.firstIndex(of: identifier) {
            favourites.remove(at: idx)
        }

        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    public func simulateEventsChanged(_ events: [Event]) {
        lastProducedSchedule?.simulateEventsChanged(events)
    }

    public func simulateDaysChanged(_ days: [Day]) {
        lastProducedSchedule?.simulateDaysChanged(days)
    }

    public func simulateDayChanged(to day: Day?) {
        lastProducedSchedule?.simulateDayChanged(to: day)
    }

}
