import EurofurenceModel
import Foundation

class CapturingScheduleRepositoryObserver: ScheduleRepositoryObserver {

    private(set) var allEvents = [Event]()
    func eventsDidChange(to events: [Event]) {
        allEvents = events
    }

    private(set) var wasProvidedWithEmptyRunningEvents = false
    private(set) var runningEvents = [Event]()
    func runningEventsDidChange(to events: [Event]) {
        wasProvidedWithEmptyRunningEvents = wasProvidedWithEmptyRunningEvents || events.isEmpty
        runningEvents = events
    }

    private(set) var wasProvidedWithEmptyUpcomingEvents = false
    private(set) var upcomingEvents = [Event]()
    func upcomingEventsDidChange(to events: [Event]) {
        wasProvidedWithEmptyUpcomingEvents = wasProvidedWithEmptyUpcomingEvents || events.isEmpty
        upcomingEvents = events
    }

    private(set) var capturedFavouriteEventIdentifiers = [EventIdentifier]()
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        capturedFavouriteEventIdentifiers = identifiers
    }

}
