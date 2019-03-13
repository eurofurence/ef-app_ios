//
//  ConcreteAnnouncementsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteAnnouncementsService: AnnouncementsService {

    // MARK: Properties

    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private var readAnnouncementIdentifiers = [AnnouncementIdentifier]()

    var models = [AnnouncementImpl]() {
        didSet {
            announcementsObservers.forEach(provideLatestData)
        }
    }

    private var announcementsObservers = [AnnouncementsServiceObserver]()

    // MARK: Initialization

    init(eventBus: EventBus, dataStore: DataStore, imageRepository: ImageRepository) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reloadAnnouncementsFromStore))

        reloadAnnouncementsFromStore()
        readAnnouncementIdentifiers = dataStore.fetchReadAnnouncementIdentifiers().defaultingTo(.empty)
    }

    // MARK: Functions

    func add(_ observer: AnnouncementsServiceObserver) {
        provideLatestData(to: observer)
        announcementsObservers.append(observer)
    }
    
    func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement? {
        if let model = models.first(where: { $0.identifier == identifier }) {
            readAnnouncementIdentifiers.append(identifier)
            announcementsObservers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers) })
            
            dataStore.performTransaction { (transaction) in
                transaction.saveReadAnnouncements(self.readAnnouncementIdentifiers)
            }
            
            return model
        } else {
            return nil
        }
    }

    func fetchAnnouncementImage(identifier: AnnouncementIdentifier, completionHandler: @escaping (Data?) -> Void) {
        let announcement = dataStore.fetchAnnouncements()?.first(where: { $0.identifier == identifier.rawValue })
        let imageData: Data? = announcement.let { (announcement) in
            let entity: ImageEntity? = announcement.imageIdentifier.let(imageRepository.loadImage)
            return entity?.pngImageData
        }

        completionHandler(imageData)
    }

    // MARK: Private

    private func reloadAnnouncementsFromStore() {
        guard let announcements = dataStore.fetchAnnouncements() else { return }
        models = announcements.sorted(by: isLastEditTimeAscending).map(AnnouncementImpl.init)
    }

    private func isLastEditTimeAscending(_ first: AnnouncementCharacteristics, _ second: AnnouncementCharacteristics) -> Bool {
        return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
    }

    private func provideLatestData(to observer: AnnouncementsServiceObserver) {
        observer.announcementsServiceDidChangeAnnouncements(models)
        observer.announcementsServiceDidUpdateReadAnnouncements(readAnnouncementIdentifiers)
    }

}
