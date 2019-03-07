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
    private let api: API
    private let imageDownloader: ImageDownloader
    private let clock: Clock
    private let eventBus: EventBus
    private let imageCache: ImagesCache
    private let imageRepository: ImageRepository

    init(longRunningTaskManager: LongRunningTaskManager?,
         dataStore: DataStore,
         api: API,
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
        self.api = api
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
        return performSync(lastSyncTime: dataStore.fetchLastRefreshDate(), completionHandler: completionHandler)
    }
    
    private enum SyncError: Error {
        case failedToLoadResponse
    }

    private func performSync(lastSyncTime: Date?, completionHandler: @escaping (Error?) -> Void) -> Progress {
        notifyRefreshStarted()
        startLongRunningTask()

        let progress = Progress()
        progress.totalUnitCount = -1
        progress.completedUnitCount = -1

        api.fetchLatestData(lastSyncTime: lastSyncTime) { (response) in
            guard let response = response else {
                self.finishLongRunningTask()
                self.notifyRefreshFinished()
                completionHandler(SyncError.failedToLoadResponse)
                return
            }

            let imageIdentifiers = response.images.changed.map({ $0.identifier })
            progress.completedUnitCount = 0
            progress.totalUnitCount = Int64(imageIdentifiers.count)

            self.imageDownloader.downloadImages(identifiers: imageIdentifiers, parentProgress: progress) {
                self.updateLocalStore(response: response, lastSyncTime: lastSyncTime)
                self.eventBus.post(DomainEvent.DataStoreChangedEvent())

                self.privateMessagesController.refreshMessages {
                    completionHandler(nil)
                    self.notifyRefreshFinished()
                    self.finishLongRunningTask()
                }
            }
        }
        
        return progress
    }
    
    private func updateLocalStore(response: ModelCharacteristics, lastSyncTime: Any?) {
        self.dataStore.performTransaction({ (transaction) in
            self.deleteRemovedEntities(response: response, transaction: transaction)
            self.deleteOrphanedRecords(response: response, transaction: transaction, lastSyncTime: lastSyncTime)
            self.processRemoveAllBeforeInserts(response, transaction: transaction)
            self.save(characteristics: response, in: transaction)
        })
    }

    private func notifyRefreshFinished() {
        self.refreshObservers.forEach({ $0.refreshServiceDidFinishRefreshing() })
    }

    private func notifyRefreshStarted() {
        refreshObservers.forEach({ $0.refreshServiceDidBeginRefreshing() })
    }
    
    private var longRunningTaskIdentifier: AnyHashable?
    private func startLongRunningTask() {
        longRunningTaskIdentifier = longRunningTaskManager?.beginLongRunningTask()
    }
    
    private func finishLongRunningTask() {
        if let identifier = longRunningTaskIdentifier {
            longRunningTaskManager?.finishLongRunningTask(token: identifier)
            longRunningTaskIdentifier = nil
        }
    }

    private func deleteRemovedEntities(response: ModelCharacteristics, transaction: DataStoreTransaction) {
        response.images.deleted.forEach(transaction.deleteImage)
        response.images.deleted.forEach(imageCache.deleteImage)
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
    
    private func deleteOrphanedRecords(response: ModelCharacteristics, transaction: DataStoreTransaction, lastSyncTime: Any?) {
        let isFullStoreRefresh: Bool = lastSyncTime == nil
        if isFullStoreRefresh {
            deleteOrphanedEntities(response: response, transaction: transaction)
        }
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
    
    private func deleteOrphanedEntities(response: ModelCharacteristics, transaction: DataStoreTransaction) {
        deleteOrphanedAnnouncements(response, transaction)
        deleteOrphanedEvents(response, transaction)
        deleteOrphanedKnowledgeGroups(response, transaction)
        deleteOrphanedKnowledgeEntries(response, transaction)
        deleteOrphanedImages(response)
        deleteOrphanedDealers(response, transaction)
        deleteOrphanedMaps(response, transaction)
    }
    
    private func deleteOrphanedAnnouncements(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        let existingAnnouncementIdentifiers = dataStore.fetchAnnouncements().defaultingTo(.empty).map({ $0.identifier })
        let changedAnnouncementIdentifiers = response.announcements.changed.map({ $0.identifier })
        let orphanedAnnouncements = existingAnnouncementIdentifiers.filter(not(changedAnnouncementIdentifiers.contains))
        orphanedAnnouncements.forEach(transaction.deleteAnnouncement)
    }
    
    private func deleteOrphanedEvents(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        let existingEventIdentifiers = dataStore.fetchEvents()?.map({ $0.identifier })
        let changedEventIdentifiers = response.events.changed.map({ $0.identifier })
        let orphanedEvents = existingEventIdentifiers?.filter(not(changedEventIdentifiers.contains))
        orphanedEvents?.forEach(transaction.deleteEvent)
    }
    
    private func deleteOrphanedKnowledgeGroups(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        let existingKnowledgeGroupIdentifiers = dataStore.fetchKnowledgeGroups()?.map({ $0.identifier })
        let changedKnowledgeGroupIdentifiers = response.knowledgeGroups.changed.map({ $0.identifier })
        let orphanedKnowledgeGroups = existingKnowledgeGroupIdentifiers?.filter(not(changedKnowledgeGroupIdentifiers.contains))
        orphanedKnowledgeGroups?.forEach(transaction.deleteKnowledgeGroup)
    }
    
    private func deleteOrphanedKnowledgeEntries(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        let existingKnowledgeEntryIdentifiers = dataStore.fetchKnowledgeEntries()?.map({ $0.identifier })
        let changedKnowledgeEntryIdentifiers = response.knowledgeEntries.changed.map({ $0.identifier })
        let orphanedKnowledgeEntries = existingKnowledgeEntryIdentifiers?.filter(not(changedKnowledgeEntryIdentifiers.contains))
        orphanedKnowledgeEntries?.forEach(transaction.deleteKnowledgeEntry)
    }
    
    private func deleteOrphanedImages(_ response: ModelCharacteristics) {
        let existingImageIdentifiers = dataStore.fetchImages()?.map({ $0.identifier })
        let changedImageIdentifiers = response.images.changed.map({ $0.identifier })
        let orphanedImages = existingImageIdentifiers?.filter(not(changedImageIdentifiers.contains))
        orphanedImages?.forEach(imageRepository.deleteEntity)
    }
    
    private func deleteOrphanedDealers(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        let existingDealerIdentifiers = dataStore.fetchDealers()?.map({ $0.identifier })
        let changedDealerIdentifiers = response.dealers.changed.map({ $0.identifier })
        let orphanedDealers = existingDealerIdentifiers?.filter(not(changedDealerIdentifiers.contains))
        orphanedDealers?.forEach(transaction.deleteDealer)
    }
    
    private func deleteOrphanedMaps(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        let existingMapIdentifiers = dataStore.fetchMaps()?.map({ $0.identifier })
        let changedMapIdentifiers = response.maps.changed.map({ $0.identifier })
        let orphanedMaps = existingMapIdentifiers?.filter(not(changedMapIdentifiers.contains))
        orphanedMaps?.forEach(transaction.deleteMap)
    }
    
    private func processRemoveAllBeforeInserts(_ response: ModelCharacteristics, transaction: DataStoreTransaction) {
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
            self.dataStore.fetchDealers()
                .defaultingTo(.empty)
                .map({ $0.identifier })
                .forEach(transaction.deleteDealer)
        }
        
        if response.images.removeAllBeforeInsert {
            let identifiers = dataStore.fetchImages()?.map({ $0.identifier })
            identifiers?.forEach(transaction.deleteImage)
            identifiers?.forEach(imageCache.deleteImage)
        }
    }

}
