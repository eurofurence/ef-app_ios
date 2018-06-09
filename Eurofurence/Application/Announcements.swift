//
//  Announcements.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Announcements {

    // MARK: Nested Types

    private class AnnouncementsUpdater: EventConsumer {

        private let announcements: Announcements

        init(announcements: Announcements) {
            self.announcements = announcements
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            let response = event.response
            let sortedAnnouncements = response.announcements.changed.sorted(by: { (first, second) -> Bool in
                return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
            })

            let models = Announcement2.fromServerModels(sortedAnnouncements)
            announcements.models = models
        }

    }

    // MARK: Properties

    private var models = [Announcement2]() {
        didSet {
            announcementsObservers.forEach(provideLatestData)
        }
    }

    private var announcementsObservers = [AnnouncementsServiceObserver]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: EurofurenceDataStore) {
        eventBus.subscribe(consumer: AnnouncementsUpdater(announcements: self))

        if let persistedAnnouncements = dataStore.getSavedAnnouncements() {
            models = persistedAnnouncements.sorted(by: { (first, second) -> Bool in
                return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
            }).map(Announcement2.init)
        }
    }

    // MARK: Functions

    func add(_ observer: AnnouncementsServiceObserver) {
        provideLatestData(to: observer)
        announcementsObservers.append(observer)
    }

    private func provideLatestData(to observer: AnnouncementsServiceObserver) {
        observer.eurofurenceApplicationDidChangeUnreadAnnouncements(to: models)
        observer.eurofurenceApplicationDidChangeAnnouncements(models)
    }

}
