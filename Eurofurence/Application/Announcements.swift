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
            announcements.updateModel(from: response.announcements.changed)
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
            updateModel(from: persistedAnnouncements)
        }
    }

    // MARK: Functions

    func add(_ observer: AnnouncementsServiceObserver) {
        provideLatestData(to: observer)
        announcementsObservers.append(observer)
    }

    private func updateModel(from announcements: [APIAnnouncement]) {
        models = announcements.sorted(by: isLastEditTimeAscending).map(Announcement2.init)
    }

    private func isLastEditTimeAscending(_ first: APIAnnouncement, _ second: APIAnnouncement) -> Bool {
        return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
    }

    private func provideLatestData(to observer: AnnouncementsServiceObserver) {
        observer.eurofurenceApplicationDidChangeUnreadAnnouncements(to: models)
        observer.eurofurenceApplicationDidChangeAnnouncements(models)
    }

}
