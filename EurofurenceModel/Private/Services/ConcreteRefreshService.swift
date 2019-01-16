//
//  ConcreteRefreshService.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteRefreshService: RefreshService {

    private let announcementsService: ConcreteAnnouncementsService
    private let schedule: ConcreteEventsService
    private let knowledgeService: ConcreteKnowledgeService
    private let privateMessagesController: ConcretePrivateMessagesService

    private let longRunningTaskManager: LongRunningTaskManager?
    private let dataStore: DataStore
    private let syncAPI: SyncAPI
    private let imageDownloader: ImageDownloader
    private let clock: Clock
    private let eventBus: EventBus
    private let imageCache: ImagesCache
    private let imageRepository: ImageRepository

    init(longRunningTaskManager: LongRunningTaskManager?,
         dataStore: DataStore,
         syncAPI: SyncAPI,
         imageDownloader: ImageDownloader,
         announcementsService: ConcreteAnnouncementsService,
         schedule: ConcreteEventsService,
         clock: Clock,
         eventBus: EventBus,
         imageCache: ImagesCache,
         imageRepository: ImageRepository,
         knowledgeService: ConcreteKnowledgeService,
         privateMessagesController: ConcretePrivateMessagesService) {
        self.longRunningTaskManager = longRunningTaskManager
        self.dataStore = dataStore
        self.syncAPI = syncAPI
        self.imageDownloader = imageDownloader
        self.announcementsService = announcementsService
        self.schedule = schedule
        self.clock = clock
        self.eventBus = eventBus
        self.imageCache = imageCache
        self.imageRepository = imageRepository
        self.knowledgeService = knowledgeService
        self.privateMessagesController = privateMessagesController
    }

    private var refreshObservers = [RefreshServiceObserver]()
    func add(_ observer: RefreshServiceObserver) {
        refreshObservers.append(observer)
    }

    func performFullStoreRefresh(completionHandler: @escaping (Error?) -> Void) -> Progress {
        return performSync(lastSyncTime: nil, completionHandler: completionHandler)
    }

    @discardableResult
    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        return performSync(lastSyncTime: dataStore.getLastRefreshDate(), completionHandler: completionHandler)
    }

    private func performSync(lastSyncTime: Date?, completionHandler: @escaping (Error?) -> Void) -> Progress {
        notifyRefreshStarted()

        let longRunningTask = longRunningTaskManager?.beginLongRunningTask()
        let finishLongRunningTask: () -> Void = {
            if let taskManager = self.longRunningTaskManager, let task = longRunningTask {
                taskManager.finishLongRunningTask(token: task)
            }
        }

        let progress = Progress()
        progress.totalUnitCount = -1
        progress.completedUnitCount = -1

        let existingAnnouncements = dataStore.getSavedAnnouncements().or([])
        let existingKnowledgeGroups = dataStore.getSavedKnowledgeGroups().or([])
        let existingKnowledgeEntries = dataStore.getSavedKnowledgeEntries().or([])
        let existingEvents = dataStore.getSavedEvents().or([])
        let existingImages = dataStore.getSavedImages().or([])
        let existingDealers = dataStore.getSavedDealers().or([])
        let existingMaps = dataStore.getSavedMaps().or([])
        syncAPI.fetchLatestData(lastSyncTime: lastSyncTime) { (response) in
            guard let response = response else {
                finishLongRunningTask()

                self.notifyRefreshFinished()

                enum SyncError: Error {
                    case failedToLoadResponse
                }

                completionHandler(SyncError.failedToLoadResponse)
                return
            }

            let imageIdentifiers = response.images.changed.map({ $0.identifier })
            progress.completedUnitCount = 0
            progress.totalUnitCount = Int64(imageIdentifiers.count)

            var imageIdentifiersToDelete: [String] = []
            if response.images.removeAllBeforeInsert {
                imageIdentifiersToDelete = existingImages.map({ $0.identifier })
                imageIdentifiersToDelete.forEach(self.imageCache.deleteImage)
            }

            self.imageDownloader.downloadImages(identifiers: imageIdentifiers, parentProgress: progress) {
                self.dataStore.performTransaction({ (transaction) in
                    self.deleteExistingEntities(imageIdentifiersToDelete: imageIdentifiersToDelete,
                                                response: response,
                                                transaction: transaction)

                    let isFullStoreRefresh: Bool = lastSyncTime == nil
                    if isFullStoreRefresh {
                        let changedAnnouncementIdentifiers = response.announcements.changed.map({ $0.identifier })
                        let orphanedAnnouncements = existingAnnouncements.map({ $0.identifier }).filter(not(changedAnnouncementIdentifiers.contains))
                        orphanedAnnouncements.forEach(transaction.deleteAnnouncement)

                        let changedEventIdentifiers = response.events.changed.map({ $0.identifier })
                        let orphanedEvents = existingEvents.map({ $0.identifier }).filter(not(changedEventIdentifiers.contains))
                        orphanedEvents.forEach(transaction.deleteEvent)

                        let changedKnowledgeGroupIdentifiers = response.knowledgeGroups.changed.map({ $0.identifier })
                        let orphanedKnowledgeGroups = existingKnowledgeGroups.map({ $0.identifier }).filter(not(changedKnowledgeGroupIdentifiers.contains))
                        orphanedKnowledgeGroups.forEach(transaction.deleteKnowledgeGroup)

                        let changedKnowledgeEntryIdentifiers = response.knowledgeEntries.changed.map({ $0.identifier })
                        let orphanedKnowledgeEntries = existingKnowledgeEntries.map({ $0.identifier }).filter(not(changedKnowledgeEntryIdentifiers.contains))
                        orphanedKnowledgeEntries.forEach(transaction.deleteKnowledgeEntry)

                        let existingImageIdentifiers = existingImages.map({ $0.identifier })
                        let changedImageIdentifiers = response.images.changed.map({ $0.identifier })
                        let orphanedImages = existingImageIdentifiers.filter(not(changedImageIdentifiers.contains))
                        orphanedImages.forEach(self.imageRepository.deleteEntity)

                        let existingDealerIdentifiers = existingDealers.map({ $0.identifier })
                        let changedDealerIdentifiers = response.dealers.changed.map({ $0.identifier })
                        let orphanedDealers = existingDealerIdentifiers.filter(not(changedDealerIdentifiers.contains))
                        orphanedDealers.forEach(transaction.deleteDealer)

                        let existingMapsIdentifiers = existingMaps.map({ $0.identifier })
                        let changedMapIdentifiers = response.maps.changed.map({ $0.identifier })
                        let orphanedMaps = existingMapsIdentifiers.filter(not(changedMapIdentifiers.contains))
                        orphanedMaps.forEach(transaction.deleteMap)
                    }

                    if response.announcements.removeAllBeforeInsert {
                        self.announcementsService.models.map({ $0.identifier.rawValue }).forEach(transaction.deleteAnnouncement)
                    }

                    if response.conferenceDays.removeAllBeforeInsert {
                        self.schedule.days.map({ $0.identifier }).forEach(transaction.deleteConferenceDay)
                    }

                    if response.rooms.removeAllBeforeInsert {
                        self.schedule.rooms.map({ $0.roomIdentifier }).forEach(transaction.deleteRoom)
                    }

                    if response.tracks.removeAllBeforeInsert {
                        self.schedule.tracks.map({ $0.trackIdentifier }).forEach(transaction.deleteTrack)
                    }

                    if response.knowledgeGroups.removeAllBeforeInsert {
                        self.knowledgeService.models.map({ $0.identifier.rawValue }).forEach(transaction.deleteKnowledgeGroup)
                    }

                    if response.knowledgeEntries.removeAllBeforeInsert {
                        self.knowledgeService.models.reduce([], { $0 + $1.entries }).map({ $0.identifier.rawValue }).forEach(transaction.deleteKnowledgeEntry)
                    }

                    if response.dealers.removeAllBeforeInsert {
                        existingDealers.map({ $0.identifier }).forEach(transaction.deleteDealer)
                    }

                    self.save(characteristics: response, in: transaction)

                    response.images.deleted.forEach(transaction.deleteImage)
                    response.images.deleted.forEach(self.imageCache.deleteImage)
                })

                self.eventBus.post(DomainEvent.DataStoreChangedEvent())

                self.privateMessagesController.refreshMessages {
                    completionHandler(nil)
                    self.notifyRefreshFinished()
                    finishLongRunningTask()
                }
            }
        }

        return progress
    }

    private func notifyRefreshFinished() {
        self.refreshObservers.forEach({ $0.refreshServiceDidFinishRefreshing() })
    }

    private func notifyRefreshStarted() {
        refreshObservers.forEach({ $0.refreshServiceDidBeginRefreshing() })
    }

    private func deleteExistingEntities(imageIdentifiersToDelete: [String],
                                        response: ModelCharacteristics,
                                        transaction: DataStoreTransaction) {
        imageIdentifiersToDelete.forEach(transaction.deleteImage)
        response.events.deleted.forEach(transaction.deleteEvent)
        response.tracks.deleted.forEach(transaction.deleteTrack)
        response.rooms.deleted.forEach(transaction.deleteRoom)
        response.conferenceDays.deleted.forEach(transaction.deleteConferenceDay)
        response.maps.deleted.forEach(transaction.deleteMap)
        response.dealers.deleted.forEach(transaction.deleteDealer)
        response.knowledgeEntries.deleted.forEach(transaction.deleteKnowledgeEntry)
        response.knowledgeGroups.deleted.forEach(transaction.deleteKnowledgeGroup)
        response.announcements.deleted.forEach(transaction.deleteAnnouncement)
    }

    private func save(characteristics: ModelCharacteristics, in transaction: DataStoreTransaction) {
        transaction.saveEvents(characteristics.events.changed)
        transaction.saveRooms(characteristics.rooms.changed)
        transaction.saveTracks(characteristics.tracks.changed)
        transaction.saveConferenceDays(characteristics.conferenceDays.changed)
        transaction.saveMaps(characteristics.maps.changed)
        transaction.saveDealers(characteristics.dealers.changed)
        transaction.saveKnowledgeGroups(characteristics.knowledgeGroups.changed)
        transaction.saveKnowledgeEntries(characteristics.knowledgeEntries.changed)
        transaction.saveAnnouncements(characteristics.announcements.changed)
        transaction.saveLastRefreshDate(clock.currentDate)
        transaction.saveImages(characteristics.images.changed)
    }

}
