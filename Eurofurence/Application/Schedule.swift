//
//  Schedule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Schedule: EventsSchedule {

    // MARK: Nested Types

    private class ScheduleUpdater: EventConsumer {

        private let schedule: Schedule

        init(schedule: Schedule) {
            self.schedule = schedule
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            let response = event.response
            schedule.updateSchedule(events: response.events.changed,
                                    rooms: response.rooms.changed,
                                    tracks: response.tracks.changed,
                                    days: response.conferenceDays.changed)
        }

    }

    // MARK: Properties

    private var observers = [EventsServiceObserver]()
    private let dataStore: EurofurenceDataStore
    private let imageCache: ImagesCache
    private let clock: Clock
    private let timeIntervalForUpcomingEventsSinceNow: TimeInterval

    private var models = [Event2]() {
        didSet {
            observers.forEach(provideScheduleInformation)
            delegate?.eventsDidChange(to: models)
        }
    }

    private var dayModels = [Day]()

    private var favouriteEventIdentifiers = [Event2.Identifier]() {
        didSet {
            favouriteEventIdentifiers.sort { (first, second) -> Bool in
                guard let firstEvent = models.first(where: { $0.identifier == first }) else { return false }
                guard let secondEvent = models.first(where: { $0.identifier == second }) else { return false }

                return firstEvent.startDate < secondEvent.startDate
            }

            provideFavouritesInformationToObservers()
        }
    }

    var runningEvents: [Event2] {
        let now = clock.currentDate
        return models.filter { (event) -> Bool in
            return DateInterval(start: event.startDate, end: event.endDate).contains(now)
        }
    }

    var upcomingEvents: [Event2] {
        let now = clock.currentDate
        let range = DateInterval(start: now, end: now.addingTimeInterval(timeIntervalForUpcomingEventsSinceNow))
        return models.filter { (event) -> Bool in
            return event.startDate > now && range.contains(event.startDate)
        }
    }

    // MARK: Initialization

    init(eventBus: EventBus,
         dataStore: EurofurenceDataStore,
         imageCache: ImagesCache,
         clock: Clock,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval) {
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.clock = clock
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow

        eventBus.subscribe(consumer: ScheduleUpdater(schedule: self))
        reconstituteEventsFromDataStore()
        reconstituteFavouritesFromDataStore()
        reconstituteDaysFromDataStore()
    }

    // MARK: EventsSchedule

    private var delegate: EventsScheduleDelegate?
    func setDelegate(_ delegate: EventsScheduleDelegate) {
        self.delegate = delegate
        delegate.eventsDidChange(to: models)
    }

    func restrictEvents(to day: Day) {

    }

    // MARK: Functions

    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)
        provideScheduleInformation(to: observer)
    }

    func favouriteEvent(identifier: Event2.Identifier) {
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }

        favouriteEventIdentifiers.append(identifier)
    }

    func unfavouriteEvent(identifier: Event2.Identifier) {
        dataStore.performTransaction { (transaction) in
            transaction.deleteFavouriteEventIdentifier(identifier)
        }

        if let idx = favouriteEventIdentifiers.index(of: identifier) {
            favouriteEventIdentifiers.remove(at: idx)
        }
    }

    // MARK: Private

    private func provideScheduleInformation(to observer: EventsServiceObserver) {
        observer.runningEventsDidChange(to: runningEvents)
        observer.upcomingEventsDidChange(to: upcomingEvents)
        observer.eventsDidChange(to: models)
        observer.favouriteEventsDidChange(favouriteEventIdentifiers)
        observer.eventDaysDidChange(to: dayModels)
    }

    private func provideFavouritesInformationToObservers() {
        observers.forEach { (observer) in
            observer.favouriteEventsDidChange(favouriteEventIdentifiers)
        }
    }

    private func reconstituteEventsFromDataStore() {
        let events = dataStore.getSavedEvents()
        let rooms = dataStore.getSavedRooms()
        let tracks = dataStore.getSavedTracks()

        if let events = events, let rooms = rooms, let tracks = tracks {
            updateSchedule(events: events, rooms: rooms, tracks: tracks, days: [])
        }
    }

    private func updateSchedule(events: [APIEvent],
                                rooms: [APIRoom],
                                tracks: [APITrack],
                                days: [APIConferenceDay]) {
        models = events.compactMap({ (event) -> Event2? in
            guard let room = rooms.first(where: { $0.roomIdentifier == event.roomIdentifier }) else { return nil }
            guard let track = tracks.first(where: { $0.trackIdentifier == event.trackIdentifier }) else { return nil }

            var posterGraphicData: Data?
            if let posterImageIdentifier = event.posterImageId {
                posterGraphicData = imageCache.cachedImageData(for: posterImageIdentifier)
            }

            var bannerGraphicData: Data?
            if let bannerImageIdentifier = event.bannerImageId {
                bannerGraphicData = imageCache.cachedImageData(for: bannerImageIdentifier)
            }

            return Event2(identifier: Event2.Identifier(event.identifier),
                          title: event.title,
                          abstract: event.abstract,
                          room: Room(name: room.name),
                          track: Track(name: track.name),
                          hosts: event.panelHosts,
                          startDate: event.startDateTime,
                          endDate: event.endDateTime,
                          eventDescription: event.eventDescription,
                          posterGraphicPNGData: posterGraphicData,
                          bannerGraphicPNGData: bannerGraphicData)
        })

        dayModels = makeDays(from: days)
        observers.forEach { $0.eventDaysDidChange(to: dayModels) }
    }

    private func reconstituteFavouritesFromDataStore() {
        favouriteEventIdentifiers = dataStore.getSavedFavouriteEventIdentifiers() ?? []
    }

    private func isFavourite(_ event: Event2) -> Bool {
        return favouriteEventIdentifiers.contains(event.identifier)
    }

    private func compareEventsByStartDate(_ first: Event2, second: Event2) -> Bool {
        return first.startDate < second.startDate
    }

    private func reconstituteDaysFromDataStore() {
        guard let conferenceDays = dataStore.getSavedConferenceDays() else { return }
        dayModels = makeDays(from: conferenceDays)
    }

    private func makeDays(from models: [APIConferenceDay]) -> [Day] {
        return models.map(makeDay).sorted()
    }

    private func makeDay(from model: APIConferenceDay) -> Day {
        return Day(date: model.date)
    }

}
