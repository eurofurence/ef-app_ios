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

    private let dataStore: EurofurenceDataStore
    private var readAnnouncementIdentifiers = [Announcement2.Identifier]()

    private var models = [Announcement2]() {
        didSet {
            announcementsObservers.forEach(provideLatestData)
        }
    }

    private var announcementsObservers = [AnnouncementsServiceObserver]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: EurofurenceDataStore) {
        self.dataStore = dataStore
        eventBus.subscribe(consumer: AnnouncementsUpdater(announcements: self))

        if let persistedAnnouncements = dataStore.getSavedAnnouncements() {
            updateModel(from: persistedAnnouncements)
        }

        if let readAnnouncements = dataStore.getSavedReadAnnouncementIdentifiers() {
            readAnnouncementIdentifiers = readAnnouncements
        }
    }

    // MARK: Functions

    func add(_ observer: AnnouncementsServiceObserver) {
        provideLatestData(to: observer)
        announcementsObservers.append(observer)
    }

    func openAnnouncement(identifier: Announcement2.Identifier, completionHandler: @escaping (Announcement2) -> Void) {
        guard let model = models.first(where: { $0.identifier == identifier }) else { return }
        completionHandler(model)

        readAnnouncementIdentifiers.append(identifier)
        announcementsObservers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers) })

        dataStore.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(self.readAnnouncementIdentifiers)
        }
    }

    // MARK: Private

    private func updateModel(from announcements: [APIAnnouncement]) {
        models = announcements.sorted(by: isLastEditTimeAscending).map(Announcement2.init)
    }

    private func isLastEditTimeAscending(_ first: APIAnnouncement, _ second: APIAnnouncement) -> Bool {
        return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
    }

    private func provideLatestData(to observer: AnnouncementsServiceObserver) {
        observer.eurofurenceApplicationDidChangeAnnouncements(models)
        observer.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers)
    }

}
