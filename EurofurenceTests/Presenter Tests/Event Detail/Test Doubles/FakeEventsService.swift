//
//  FakeEventsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class FakeEventsService: EventsService {

    var runningEvents: [Event] = []
    var upcomingEvents: [Event] = []
    var allEvents: [Event] = []
    var favourites: [EventIdentifier] = []

    init(favourites: [EventIdentifier] = []) {
        self.favourites = favourites
    }

    var events = [Event]()
    func fetchEvent(identifier: EventIdentifier) -> Event? {
        return events.first(where: { $0.identifier == identifier })
    }

    private var observers = [EventsServiceObserver]()
    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)

        observer.eventsDidChange(to: allEvents)
        observer.runningEventsDidChange(to: runningEvents)
        observer.upcomingEventsDidChange(to: upcomingEvents)
        observer.favouriteEventsDidChange(favourites)
    }

    private(set) var lastProducedSchedule: FakeEventsSchedule?
    func makeEventsSchedule() -> EventsSchedule {
        let schedule = FakeEventsSchedule(events: allEvents)
        lastProducedSchedule = schedule
        return schedule
    }

    private(set) var lastProducedSearchController: FakeEventsSearchController?
    func makeEventsSearchController() -> EventsSearchController {
        let searchController = FakeEventsSearchController()
        lastProducedSearchController = searchController
        return searchController
    }

}

extension FakeEventsService {

    func stubSomeFavouriteEvents() {
        allEvents = [FakeEvent].random(minimum: 3)
        favourites = Array(allEvents.dropFirst()).map({ $0.identifier })
    }

    func simulateEventFavourited(identifier: EventIdentifier) {
        favourites.append(identifier)
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    func simulateEventFavouritesChanged(to identifiers: [EventIdentifier]) {
        favourites = identifiers
        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    func simulateEventUnfavourited(identifier: EventIdentifier) {
        if let idx = favourites.firstIndex(of: identifier) {
            favourites.remove(at: idx)
        }

        observers.forEach { $0.favouriteEventsDidChange(favourites) }
    }

    func simulateEventsChanged(_ events: [Event]) {
        lastProducedSchedule?.simulateEventsChanged(events)
    }

    func simulateDaysChanged(_ days: [Day]) {
        lastProducedSchedule?.simulateDaysChanged(days)
    }

    func simulateDayChanged(to day: Day?) {
        lastProducedSchedule?.simulateDayChanged(to: day)
    }

}
