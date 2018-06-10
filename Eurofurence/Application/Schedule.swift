//
//  Schedule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Schedule {

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
                                    tracks: response.tracks.changed)
        }

    }

    // MARK: Properties

    private var observers = [EventsServiceObserver]()
    private let imageCache: ImagesCache
    private let clock: Clock
    private let timeIntervalForUpcomingEventsSinceNow: TimeInterval

    private var models = [Event2]() {
        didSet {
            observers.forEach(provideScheduleInformation)
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
        self.imageCache = imageCache
        self.clock = clock
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow

        eventBus.subscribe(consumer: ScheduleUpdater(schedule: self))
        reconstituteEvents(from: dataStore)
    }

    // MARK: Functions

    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: runningEvents)
        observer.eurofurenceApplicationDidUpdateUpcomingEvents(to: upcomingEvents)
        observer.eurofurenceApplicationDidUpdateEvents(to: models)
    }

    // MARK: Private

    private func provideScheduleInformation(to observer: EventsServiceObserver) {
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: runningEvents)
        observer.eurofurenceApplicationDidUpdateUpcomingEvents(to: upcomingEvents)
    }

    private func reconstituteEvents(from dataStore: EurofurenceDataStore) {
        let events = dataStore.getSavedEvents()
        let rooms = dataStore.getSavedRooms()
        let tracks = dataStore.getSavedTracks()

        if let events = events, let rooms = rooms, let tracks = tracks {
            updateSchedule(events: events, rooms: rooms, tracks: tracks)
        }
    }

    private func updateSchedule(events: [APIEvent], rooms: [APIRoom], tracks: [APITrack]) {
        models = events.flatMap({ (event) -> Event2? in
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

            return Event2(title: event.title,
                          abstract: event.abstract,
                          room: Room(name: room.name),
                          track: Track(name: track.name),
                          hosts: event.panelHosts,
                          startDate: event.startDateTime,
                          endDate: event.endDateTime,
                          eventDescription: event.eventDescription,
                          posterGraphicPNGData: posterGraphicData,
                          bannerGraphicPNGData: bannerGraphicData,
                          isFavourite: false)
        })

        observers.forEach({ $0.eurofurenceApplicationDidUpdateEvents(to: models) })
    }

}
