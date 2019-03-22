//
//  ConcreteEventsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteEventsService: ClockDelegate, EventsService {

    // MARK: Nested Types

    struct ChangedEvent {}

    struct EventUnfavouritedEvent {
        var identifier: EventIdentifier
    }

    private class FavouriteEventHandler: EventConsumer {

        private let service: ConcreteEventsService

        init(service: ConcreteEventsService) {
            self.service = service
        }

        func consume(event: DomainEvent.FavouriteEvent) {
            let identifier = event.identifier
            service.persistFavouritedEvent(identifier: identifier)
            service.favouriteEventIdentifiers.append(identifier)
        }

    }

    private class UnfavouriteEventHandler: EventConsumer {

        private let service: ConcreteEventsService

        init(service: ConcreteEventsService) {
            self.service = service
        }

        func consume(event: DomainEvent.UnfavouriteEvent) {
            let identifier = event.identifier

            service.dataStore.performTransaction { (transaction) in
                transaction.deleteFavouriteEventIdentifier(identifier)
            }

            service.favouriteEventIdentifiers.index(of: identifier).let({ service.favouriteEventIdentifiers.remove(at: $0) })

            let event = EventUnfavouritedEvent(identifier: identifier)
            service.eventBus.post(event)
        }

    }

    // MARK: Properties

    private var observers = [EventsServiceObserver]()
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let clock: Clock
    private let timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private let eventBus: EventBus

    private(set) var events = [EventCharacteristics]()
    private(set) var rooms = [RoomCharacteristics]()
    private(set) var tracks = [TrackCharacteristics]()
    private(set) var days = [ConferenceDayCharacteristics]()

    private var runningEvents: [EventImpl] = []
    private var upcomingEvents: [EventImpl] = []

    private(set) var eventModels = [EventImpl]() {
        didSet {
            refreshEventProperties()
        }
    }

    private(set) var dayModels = [Day]()

    private(set) var favouriteEventIdentifiers = [EventIdentifier]() {
        didSet {
            favouriteEventIdentifiers.sort { (first, second) -> Bool in
                guard let firstEvent = eventModels.first(where: { $0.identifier == first }) else { return false }
                guard let secondEvent = eventModels.first(where: { $0.identifier == second }) else { return false }

                return firstEvent.startDate < secondEvent.startDate
            }

            provideFavouritesInformationToObservers()
        }
    }

    // MARK: Initialization

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageCache: ImagesCache,
         clock: Clock,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval) {
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.clock = clock
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        self.eventBus = eventBus

        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reconstituteEventsFromDataStore))
        eventBus.subscribe(consumer: FavouriteEventHandler(service: self))
        eventBus.subscribe(consumer: UnfavouriteEventHandler(service: self))

        reconstituteEventsFromDataStore()
        reconstituteFavouritesFromDataStore()
        clock.setDelegate(self)
    }

    func clockDidTick(to time: Date) {
        refreshUpcomingEvents()
        updateObserversWithLatestScheduleInformation()
    }

    func eventsSatisfying(predicate: (Event) -> Bool) -> [Event] {
        return eventModels.filter(predicate)
    }

    // MARK: Functions

    func fetchEvent(identifier: EventIdentifier) -> Event? {
        return eventModels.first(where: { $0.identifier == identifier })
    }

    func makeEventsSchedule() -> EventsSchedule {
        return EventsScheduleAdapter(schedule: self, clock: clock, eventBus: eventBus)
    }

    func makeEventsSearchController() -> EventsSearchController {
        return InMemoryEventsSearchController(schedule: self, eventBus: eventBus)
    }

    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)
        provideScheduleInformation(to: observer)
    }

    // MARK: Private

    private func refreshEventProperties() {
        refreshRunningEvents()
        refreshUpcomingEvents()

        updateObserversWithLatestScheduleInformation()
    }

    private func refreshRunningEvents() {
        let now = clock.currentDate
        runningEvents = eventModels.filter { (event) -> Bool in
            return DateInterval(start: event.startDate, end: event.endDate).contains(now)
        }
    }

    private func refreshUpcomingEvents() {
        let now = clock.currentDate
        let range = DateInterval(start: now, end: now.addingTimeInterval(timeIntervalForUpcomingEventsSinceNow))
        upcomingEvents = eventModels.filter { (event) -> Bool in
            return event.startDate > now && range.contains(event.startDate)
        }
    }

    private func updateObserversWithLatestScheduleInformation() {
        observers.forEach(provideScheduleInformation)
    }

    private func provideScheduleInformation(to observer: EventsServiceObserver) {
        observer.runningEventsDidChange(to: runningEvents)
        observer.upcomingEventsDidChange(to: upcomingEvents)
        observer.eventsDidChange(to: eventModels)
        observer.favouriteEventsDidChange(favouriteEventIdentifiers)
    }

    private func provideFavouritesInformationToObservers() {
        observers.forEach { (observer) in
            observer.favouriteEventsDidChange(favouriteEventIdentifiers)
        }
    }

    private func reconstituteEventsFromDataStore() {
        let events = dataStore.fetchEvents()
        let rooms = dataStore.fetchRooms()
        let tracks = dataStore.fetchTracks()
        let conferenceDays = dataStore.fetchConferenceDays()

        if let events = events, let rooms = rooms, let tracks = tracks, let conferenceDays = conferenceDays {
            self.days = conferenceDays.reduce(.empty, { (result, next) in
                if result.contains(where: { $0.identifier == next.identifier }) { return result }
                return result + [next]
            })

            self.events = events
            self.rooms = rooms
            self.tracks = tracks

            eventModels = events.compactMap(makeEventModel)

            dayModels = makeDays(from: days)
            eventBus.post(ConcreteEventsService.ChangedEvent())
        }
    }

    func makeEventModel(from event: EventCharacteristics) -> EventImpl? {
        guard let room = rooms.first(where: { $0.identifier == event.roomIdentifier }) else { return nil }
        guard let track = tracks.first(where: { $0.identifier == event.trackIdentifier }) else { return nil }

        let posterGraphicData: Data? = event.posterImageId.let(imageCache.cachedImageData)
        let bannerGraphicData: Data? = event.bannerImageId.let(imageCache.cachedImageData)

        let tags = event.tags
        let containsTag: (String) -> Bool = { tags?.contains($0) ?? false }

        let title: String = {
            if containsTag("essential_subtitle") {
                return event.title.appending(" - ").appending(event.subtitle)
            } else {
                return event.title
            }
        }()

        let eventIdentifier = EventIdentifier(event.identifier)
        let favouriteEventIdentifiers = dataStore.fetchFavouriteEventIdentifiers().defaultingTo([])

        return EventImpl(eventBus: eventBus,
                         isFavourite: favouriteEventIdentifiers.contains(eventIdentifier),
                         identifier: eventIdentifier,
                         title: title,
                         subtitle: event.subtitle,
                         abstract: event.abstract,
                         room: Room(name: room.name),
                         track: Track(name: track.name),
                         hosts: event.panelHosts,
                         startDate: event.startDateTime,
                         endDate: event.endDateTime,
                         eventDescription: event.eventDescription,
                         posterGraphicPNGData: posterGraphicData,
                         bannerGraphicPNGData: bannerGraphicData,
                         isSponsorOnly: containsTag("sponsors_only"),
                         isSuperSponsorOnly: containsTag("supersponsors_only"),
                         isArtShow: containsTag("art_show"),
                         isKageEvent: containsTag("kage"),
                         isDealersDen: containsTag("dealers_den"),
                         isMainStage: containsTag("main_stage"),
                         isPhotoshoot: containsTag("photoshoot"))
    }

    private func reconstituteFavouritesFromDataStore() {
        favouriteEventIdentifiers = dataStore.fetchFavouriteEventIdentifiers().defaultingTo(.empty)
    }

    private func makeDays(from models: [ConferenceDayCharacteristics]) -> [Day] {
        return models.map(makeDay).sorted()
    }

    private func makeDay(from model: ConferenceDayCharacteristics) -> Day {
        return Day(date: model.date)
    }

    private func persistFavouritedEvent(identifier: EventIdentifier) {
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }
    }

}
