import EurofurenceModel
import Foundation

public class FakeScheduleRepository: ScheduleRepository {

    public var runningEvents: [Event] = []
    public var upcomingEvents: [Event] = []
    public var allEvents: [Event] = []
    public var favourites: [EventIdentifier] = []
    private var currentDay: Day?

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
    private var schedulesByTag = [String: FakeEventsSchedule]()
    public func loadSchedule(tag: String) -> Schedule {
        let schedule = FakeEventsSchedule(events: allEvents, currentDay: currentDay)
        lastProducedSchedule = schedule
        schedulesByTag[tag] = schedule
        return schedule
    }
    
    public func schedule(for tag: String) -> FakeEventsSchedule? {
        return schedulesByTag[tag]
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
        allEvents.dropFirst().forEach({ $0.favourite() })
        favourites = allEvents.filter(\.isFavourite).map(\.identifier)
    }

    public func simulateEventFavourited(identifier: EventIdentifier) {
        allEvents.first(where: { $0.identifier == identifier })?.favourite()
        
        // Legacy pathway.
        let favourites = allEvents.filter(\.isFavourite).map(\.identifier)
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    public func simulateEventFavouritesChanged(to identifiers: [EventIdentifier]) {
        identifiers.forEach(simulateEventFavourited(identifier:))
    }

    public func simulateEventUnfavourited(identifier: EventIdentifier) {
        allEvents.first(where: { $0.identifier == identifier })?.unfavourite()
        
        // Legacy pathway.
        if let idx = favourites.firstIndex(of: identifier) {
            favourites.remove(at: idx)
        }
        
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    public func simulateEventsChanged(_ events: [Event]) {
        schedulesByTag.values.forEach({ $0.simulateEventsChanged(events) })
    }

    public func simulateDaysChanged(_ days: [Day]) {
        schedulesByTag.values.forEach({ $0.simulateDaysChanged(days) })
    }

    public func simulateDayChanged(to day: Day?) {
        currentDay = day
        schedulesByTag.values.forEach({ $0.simulateDayChanged(to: day) })
    }

}
