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
         clock: Clock,
         eventBus: EventBus,
         imageCache: ImagesCache,
         imageRepository: ImageRepository,
         privateMessagesController: ConcretePrivateMessagesService) {
        self.longRunningTaskManager = longRunningTaskManager
        self.dataStore = dataStore
        self.api = api
        self.imageDownloader = imageDownloader
        self.clock = clock
        self.eventBus = eventBus
        self.imageCache = imageCache
        self.imageRepository = imageRepository
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

            let imageDownloadRequests = response.images.changed.map(ImageDownloader.DownloadRequest.init)
            progress.completedUnitCount = 0
            progress.totalUnitCount = Int64(imageDownloadRequests.count)

            self.imageDownloader.downloadImages(requests: imageDownloadRequests, parentProgress: progress) {
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
        deleteOrphans(existing: dataStore.fetchAnnouncements()?.map({ $0.identifier }),
                      changed: response.announcements.changed.map({ $0.identifier }),
                      deletionHandler: transaction.deleteAnnouncement)
    }
    
    private func deleteOrphanedEvents(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        deleteOrphans(existing: dataStore.fetchEvents()?.map({ $0.identifier }),
                      changed: response.events.changed.map({ $0.identifier }),
                      deletionHandler: transaction.deleteEvent)
    }
    
    private func deleteOrphanedKnowledgeGroups(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        deleteOrphans(existing: dataStore.fetchKnowledgeGroups()?.map({ $0.identifier }),
                      changed: response.knowledgeGroups.changed.map({ $0.identifier }),
                      deletionHandler: transaction.deleteKnowledgeGroup)
    }
    
    private func deleteOrphanedKnowledgeEntries(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        deleteOrphans(existing: dataStore.fetchKnowledgeEntries()?.map({ $0.identifier }),
                      changed: response.knowledgeEntries.changed.map({ $0.identifier }),
                      deletionHandler: transaction.deleteKnowledgeEntry)
    }
    
    private func deleteOrphanedImages(_ response: ModelCharacteristics) {
        deleteOrphans(existing: dataStore.fetchImages()?.map({ $0.identifier }),
                      changed: response.images.changed.map({ $0.identifier }),
                      deletionHandler: imageRepository.deleteEntity)
    }
    
    private func deleteOrphanedDealers(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        deleteOrphans(existing: dataStore.fetchDealers()?.map({ $0.identifier }),
                      changed: response.dealers.changed.map({ $0.identifier }),
                      deletionHandler: transaction.deleteDealer)
    }
    
    private func deleteOrphanedMaps(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
        deleteOrphans(existing: dataStore.fetchMaps()?.map({ $0.identifier }),
                      changed: response.maps.changed.map({ $0.identifier }),
                      deletionHandler: transaction.deleteMap)
    }
    
    private func deleteOrphans(existing: [String]?, changed: [String], deletionHandler: (String) -> Void) {
        existing?.filter(not(changed.contains)).forEach(deletionHandler)
    }
    
    private func processRemoveAllBeforeInserts(_ response: ModelCharacteristics, transaction: DataStoreTransaction) {
        if response.announcements.removeAllBeforeInsert {
            dataStore.fetchAnnouncements()?.map({ $0.identifier }).forEach(transaction.deleteAnnouncement)
        }
        
        if response.conferenceDays.removeAllBeforeInsert {
            dataStore.fetchConferenceDays()?.map({ $0.identifier }).forEach(transaction.deleteConferenceDay)
        }
        
        if response.rooms.removeAllBeforeInsert {
            dataStore.fetchRooms()?.map({ $0.roomIdentifier }).forEach(transaction.deleteRoom)
        }
        
        if response.tracks.removeAllBeforeInsert {
            dataStore.fetchTracks()?.map({ $0.trackIdentifier }).forEach(transaction.deleteTrack)
        }
        
        if response.knowledgeGroups.removeAllBeforeInsert {
            dataStore.fetchKnowledgeGroups()?.map({ $0.identifier }).forEach(transaction.deleteKnowledgeGroup)
        }
        
        if response.knowledgeEntries.removeAllBeforeInsert {
            dataStore.fetchKnowledgeEntries()?.map({ $0.identifier }).forEach(transaction.deleteKnowledgeEntry)
        }
        
        if response.dealers.removeAllBeforeInsert {
            dataStore.fetchDealers()?.map({ $0.identifier }).forEach(transaction.deleteDealer)
        }
        
        if response.images.removeAllBeforeInsert {
            dataStore.fetchImages()?.map({ $0.identifier }).forEach({ (identifier) in
                transaction.deleteImage(identifier: identifier)
                imageCache.deleteImage(identifier: identifier)
            })
        }
    }

}
