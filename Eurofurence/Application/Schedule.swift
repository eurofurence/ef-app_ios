//
//  Schedule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

private protocol EventFilter {

    func shouldFilter(event: APIEvent) -> Bool

}

class EventsScheduleAdapter: EventsSchedule, EventConsumer {

    private let schedule: Schedule
    private let clock: Clock
    private var events = [Event2]()
    private var filters = [EventFilter]()
    private var currentDay: Day? {
        didSet {
            delegate?.currentEventDayDidChange(to: currentDay)
        }
    }

    private struct DayRestrictionFilter: EventFilter {

        var day: APIConferenceDay

        func shouldFilter(event: APIEvent) -> Bool {
            return event.dayIdentifier == day.identifier
        }

    }

    private struct UpdateCurrentDayWhenSignificantTimePasses: EventConsumer {

        var scheduleAdapter: EventsScheduleAdapter

        func consume(event: DomainEvent.SignificantTimePassedEvent) {
            scheduleAdapter.updateCurrentDay()
        }

    }

    init(schedule: Schedule, clock: Clock, eventBus: EventBus) {
        self.schedule = schedule
        self.clock = clock
        events = schedule.eventModels

        eventBus.subscribe(consumer: self)
        eventBus.subscribe(consumer: UpdateCurrentDayWhenSignificantTimePasses(scheduleAdapter: self))
        regenerateSchedule()
        updateCurrentDay()
    }

    private var delegate: EventsScheduleDelegate?
    func setDelegate(_ delegate: EventsScheduleDelegate) {
        self.delegate = delegate

        delegate.scheduleEventsDidChange(to: events)
        updateDelegateWithAllDays()
        delegate.currentEventDayDidChange(to: currentDay)
    }

    func restrictEvents(to day: Day) {
        guard let day = findDay(for: day.date) else { return }
        restrictScheduleToEvents(on: day)
    }

    private func restrictScheduleToEvents(on day: APIConferenceDay) {
        if let idx = filters.index(where: { $0 is DayRestrictionFilter }) {
            let filter = filters[idx] as! DayRestrictionFilter
            guard filter.day != day else { return }
            filters.remove(at: idx)
        }

        let filter = DayRestrictionFilter(day: day)
        filters.append(filter)

        regenerateSchedule()
    }

    private func updateCurrentDay() {
        if let day = findDay(for: clock.currentDate) {
            currentDay = Day(date: day.date)
            restrictScheduleToEvents(on: day)
        } else {
            currentDay = nil

            if let firstDay = schedule.days.sorted(by: { $0.date < $1.date }).first {
                restrictScheduleToEvents(on: firstDay)
            }
        }
    }

    private func regenerateSchedule() {
        var allEvents = schedule.events
        filters.forEach { (filter) in
            allEvents = allEvents.filter(filter.shouldFilter)
        }

        events = allEvents.compactMap(schedule.makeEventModel)
        delegate?.scheduleEventsDidChange(to: events)
    }

    private func findDay(for date: Date) -> APIConferenceDay? {
        let dateOnlyComponents = resolveDateOnlyComponents(from: date)

        return schedule.days.first { (day) in
            let dayComponents = resolveDateOnlyComponents(from: day.date)
            return dayComponents == dateOnlyComponents
        }
    }

    private func resolveDateOnlyComponents(from date: Date) -> DateComponents {
        let dateCalendarComponents: Set<Calendar.Component> = Set([.day, .month, .year])
        let calendar = Calendar.current
        return calendar.dateComponents(dateCalendarComponents, from: date)
    }

    private func updateDelegateWithAllDays() {
        delegate?.eventDaysDidChange(to: schedule.dayModels)
    }

    func consume(event: Schedule.ChangedEvent) {
        updateCurrentDay()
        regenerateSchedule()
        updateDelegateWithAllDays()
    }

}

class Schedule {

    // MARK: Nested Types

    struct ChangedEvent {}

    struct EventUnfavouritedEvent {
        var identifier: Event2.Identifier
    }

    private class ScheduleUpdater: EventConsumer {

        private let schedule: Schedule

        init(schedule: Schedule) {
            self.schedule = schedule
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            let response = event.response
            schedule.updateSchedule(events: response.events,
                                    rooms: response.rooms,
                                    tracks: response.tracks,
                                    days: response.conferenceDays.changed)
        }

    }

    // MARK: Properties

    private var observers = [EventsServiceObserver]()
    private let dataStore: EurofurenceDataStore
    private let imageCache: ImagesCache
    private let clock: Clock
    private let timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private let eventBus: EventBus
    private let notificationsService: NotificationsService
    private let userPreferences: UserPreferences
    private let hoursDateFormatter: HoursDateFormatter

    private(set) var events = [APIEvent]()
    private(set) var rooms = [APIRoom]()
    private(set) var tracks = [APITrack]()
    private(set) var days = [APIConferenceDay]()

    private(set) var eventModels = [Event2]() {
        didSet {
            observers.forEach(provideScheduleInformation)
        }
    }

    var dayModels = [Day]()

    private(set) var favouriteEventIdentifiers = [Event2.Identifier]() {
        didSet {
            favouriteEventIdentifiers.sort { (first, second) -> Bool in
                guard let firstEvent = eventModels.first(where: { $0.identifier == first }) else { return false }
                guard let secondEvent = eventModels.first(where: { $0.identifier == second }) else { return false }

                return firstEvent.startDate < secondEvent.startDate
            }

            provideFavouritesInformationToObservers()
        }
    }

    var runningEvents: [Event2] {
        let now = clock.currentDate
        return eventModels.filter { (event) -> Bool in
            return DateInterval(start: event.startDate, end: event.endDate).contains(now)
        }
    }

    var upcomingEvents: [Event2] {
        let now = clock.currentDate
        let range = DateInterval(start: now, end: now.addingTimeInterval(timeIntervalForUpcomingEventsSinceNow))
        return eventModels.filter { (event) -> Bool in
            return event.startDate > now && range.contains(event.startDate)
        }
    }

    // MARK: Initialization

    init(eventBus: EventBus,
         dataStore: EurofurenceDataStore,
         imageCache: ImagesCache,
         clock: Clock,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval,
         notificationsService: NotificationsService,
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

        eventBus.subscribe(consumer: ScheduleUpdater(schedule: self))
        reconstituteEventsFromDataStore()
        reconstituteFavouritesFromDataStore()
    }

    // MARK: Functions

    func makeScheduleAdapter() -> EventsSchedule {
        return EventsScheduleAdapter(schedule: self, clock: clock, eventBus: eventBus)
    }

    func makeEventsSearchController() -> EventsSearchController {
        return InMemoryEventsSearchController(schedule: self, eventBus: eventBus)
    }

    func fetchEvent(for identifier: Event2.Identifier, completionHandler: @escaping (Event2?) -> Void) {
        let event = eventModels.first(where: { $0.identifier == identifier })
        completionHandler(event)
    }

    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)
        provideScheduleInformation(to: observer)
    }

    func favouriteEvent(identifier: Event2.Identifier) {
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }

        favouriteEventIdentifiers.append(identifier)

        guard let event = eventModels.first(where: { $0.identifier == identifier }) else { return }

        let waitInterval = userPreferences.upcomingEventReminderInterval * -1
        let reminderDate = event.startDate.addingTimeInterval(waitInterval)
        let startTimeString = hoursDateFormatter.hoursString(from: event.startDate)
        let body = String.eventReminderBody(timeString: startTimeString, roomName: event.room.name)
        let userInfo: [ApplicationNotificationKey: String] = [
            .notificationContentKind: ApplicationNotificationContentKind.event.rawValue,
            .notificationContentIdentifier: identifier.rawValue
        ]

        notificationsService.scheduleReminderForEvent(identifier: identifier,
                                                      scheduledFor: reminderDate,
                                                      title: event.title,
                                                      body: body,
                                                      userInfo: userInfo)
    }

    func unfavouriteEvent(identifier: Event2.Identifier) {
        dataStore.performTransaction { (transaction) in
            transaction.deleteFavouriteEventIdentifier(identifier)
        }

        if let idx = favouriteEventIdentifiers.index(of: identifier) {
            favouriteEventIdentifiers.remove(at: idx)
        }

        notificationsService.removeEventReminder(for: identifier)

        let event = EventUnfavouritedEvent(identifier: identifier)
        eventBus.post(event)
    }

    // MARK: Private

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
            self.days = conferenceDays
            self.events = events
            self.rooms = rooms
            self.tracks = tracks

            eventModels = events.compactMap(makeEventModel)

            dayModels = makeDays(from: days)
            eventBus.post(Schedule.ChangedEvent())
        }
    }

    private func updateSchedule(events: APISyncDelta<APIEvent>,
                                rooms: APISyncDelta<APIRoom>,
                                tracks: APISyncDelta<APITrack>,
                                days: [APIConferenceDay]) {
        dataStore.performTransaction { (transaction) in
            events.deleted.forEach(transaction.deleteEvent)
            tracks.deleted.forEach(transaction.deleteTrack)
            rooms.deleted.forEach(transaction.deleteRoom)

            transaction.saveEvents(events.changed)
            transaction.saveRooms(rooms.changed)
            transaction.saveTracks(tracks.changed)
            transaction.saveConferenceDays(days)
        }

        reconstituteEventsFromDataStore()
    }

    fileprivate func makeEventModel(from event: APIEvent) -> Event2? {
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

    private func makeDays(from models: [APIConferenceDay]) -> [Day] {
        return models.map(makeDay).sorted()
    }

    private func makeDay(from model: APIConferenceDay) -> Day {
        return Day(date: model.date)
    }

}
