//
//  Schedule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class Schedule: ClockDelegate {

    // MARK: Nested Types

    struct ChangedEvent {}

    struct EventUnfavouritedEvent {
        var identifier: Event.Identifier
    }

    // MARK: Properties

    private var observers = [EventsServiceObserver]()
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let clock: Clock
    private let timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private let eventBus: EventBus
    private let notificationsService: NotificationsService?
    private let userPreferences: UserPreferences
    private let hoursDateFormatter: HoursDateFormatter

    private(set) var events = [APIEvent]()
    private(set) var rooms = [APIRoom]()
    private(set) var tracks = [APITrack]()
    private(set) var days = [APIConferenceDay]()

    private(set) var eventModels = [Event]() {
        didSet {
            updateObserversWithLatestScheduleInformation()
        }
    }

    private(set) var dayModels = [Day]()

    private(set) var favouriteEventIdentifiers = [Event.Identifier]() {
        didSet {
            favouriteEventIdentifiers.sort { (first, second) -> Bool in
                guard let firstEvent = eventModels.first(where: { $0.identifier == first }) else { return false }
                guard let secondEvent = eventModels.first(where: { $0.identifier == second }) else { return false }

                return firstEvent.startDate < secondEvent.startDate
            }

            provideFavouritesInformationToObservers()
        }
    }

    var runningEvents: [Event] {
        let now = clock.currentDate
        return eventModels.filter { (event) -> Bool in
            return DateInterval(start: event.startDate, end: event.endDate).contains(now)
        }
    }

    var upcomingEvents: [Event] {
        let now = clock.currentDate
        let range = DateInterval(start: now, end: now.addingTimeInterval(timeIntervalForUpcomingEventsSinceNow))
        return eventModels.filter { (event) -> Bool in
            return event.startDate > now && range.contains(event.startDate)
        }
    }

    // MARK: Initialization

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageCache: ImagesCache,
         clock: Clock,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval,
         notificationsService: NotificationsService?,
         userPreferences: UserPreferences,
         hoursDateFormatter: HoursDateFormatter) {
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.clock = clock
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        self.eventBus = eventBus
        self.notificationsService = notificationsService
        self.userPreferences = userPreferences
        self.hoursDateFormatter = hoursDateFormatter

        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reconstituteEventsFromDataStore))
        reconstituteEventsFromDataStore()
        reconstituteFavouritesFromDataStore()
        clock.setDelegate(self)
    }

    func clockDidTick(to time: Date) {
        updateObserversWithLatestScheduleInformation()
    }

    // MARK: Functions

    func makeScheduleAdapter() -> EventsSchedule {
        return EventsScheduleAdapter(schedule: self, clock: clock, eventBus: eventBus)
    }

    func makeEventsSearchController() -> EventsSearchController {
        return InMemoryEventsSearchController(schedule: self, eventBus: eventBus)
    }

    func fetchEvent(for identifier: Event.Identifier, completionHandler: @escaping (Event?) -> Void) {
        let event = eventModels.first(where: { $0.identifier == identifier })
        completionHandler(event)
    }

    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)
        provideScheduleInformation(to: observer)
    }

    func favouriteEvent(identifier: Event.Identifier) {
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }

        favouriteEventIdentifiers.append(identifier)

        guard let event = eventModels.first(where: { $0.identifier == identifier }) else { return }

        let waitInterval = userPreferences.upcomingEventReminderInterval * -1
        let reminderDate = event.startDate.addingTimeInterval(waitInterval)
        let startTimeString = hoursDateFormatter.hoursString(from: event.startDate)
        let body = AppCoreStrings.eventReminderBody(timeString: startTimeString, roomName: event.room.name)
        let userInfo: [ApplicationNotificationKey: String] = [
            .notificationContentKind: ApplicationNotificationContentKind.event.rawValue,
            .notificationContentIdentifier: identifier.rawValue
        ]

        notificationsService?.scheduleReminderForEvent(identifier: identifier,
                                                       scheduledFor: reminderDate,
                                                       title: event.title,
                                                       body: body,
                                                       userInfo: userInfo)
    }

    func unfavouriteEvent(identifier: Event.Identifier) {
        dataStore.performTransaction { (transaction) in
            transaction.deleteFavouriteEventIdentifier(identifier)
        }

        favouriteEventIdentifiers.index(of: identifier).let({ favouriteEventIdentifiers.remove(at: $0) })
        notificationsService?.removeEventReminder(for: identifier)

        let event = EventUnfavouritedEvent(identifier: identifier)
        eventBus.post(event)
    }

    // MARK: Private

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
        let events = dataStore.getSavedEvents()
        let rooms = dataStore.getSavedRooms()
        let tracks = dataStore.getSavedTracks()
        let conferenceDays = dataStore.getSavedConferenceDays()

        if let events = events, let rooms = rooms, let tracks = tracks, let conferenceDays = conferenceDays {
            self.days = conferenceDays.reduce([], { (result, next) in
                if result.contains(where: { $0.identifier == next.identifier }) { return result }
                return result + [next]
            })

            self.events = events
            self.rooms = rooms
            self.tracks = tracks

            eventModels = events.compactMap(makeEventModel)

            dayModels = makeDays(from: days)
            eventBus.post(Schedule.ChangedEvent())
        }
    }

    func makeEventModel(from event: APIEvent) -> Event? {
        guard let room = rooms.first(where: { $0.roomIdentifier == event.roomIdentifier }) else { return nil }
        guard let track = tracks.first(where: { $0.trackIdentifier == event.trackIdentifier }) else { return nil }

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

        return Event(identifier: Event.Identifier(event.identifier),
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
        favouriteEventIdentifiers = dataStore.getSavedFavouriteEventIdentifiers().or([])
    }

    private func makeDays(from models: [APIConferenceDay]) -> [Day] {
        return models.map(makeDay).sorted()
    }

    private func makeDay(from model: APIConferenceDay) -> Day {
        return Day(date: model.date)
    }

}
