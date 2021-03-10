import Foundation

class RefreshChain {
    
    private let first: Node
    
    init(
        conventionIdentifier: ConventionIdentifier,
        forceRefreshRequired: ForceRefreshRequired,
        dataStore: DataStore,
        api: API,
        imageDownloader: ImageDownloader,
        eventBus: EventBus,
        imageCache: ImagesCache,
        privateMessagesController: ConcretePrivateMessagesService,
        refreshCollaboration: RefreshCollaboration,
        clock: Clock,
        imageRepository: ImageRepository
    ) {
        let executeCollaboration = ExecuteRefreshCollaborationNode(
            next: nil,
            refreshCollaboration: refreshCollaboration
        )
        
        let fetchMessages = FetchPrivateMessagesNode(
            next: executeCollaboration,
            privateMessagesController: privateMessagesController
        )
        
        let fetchModel = FetchRemoteModelAndImages(
            next: fetchMessages,
            conventionIdentifier: conventionIdentifier,
            forceRefreshRequired: forceRefreshRequired,
            dataStore: dataStore,
            api: api,
            imageDownloader: imageDownloader,
            eventBus: eventBus,
            imageCache: imageCache,
            clock: clock,
            imageRepository: imageRepository
        )
        
        first = fetchModel
    }
    
    class Node {
        
        private var next: Node?
        private var chainComplete: ((RefreshServiceError?) -> Void)?
        
        init(next: Node?) {
            self.next = next
        }
        
        func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
            self.chainComplete = chainComplete
        }
        
        final func finish(progress: Progress, error: RefreshServiceError?) {
            if let error = error {
                chainComplete?(error)
            } else if let next = next {
                next.start(progress: progress, chainComplete: chainComplete)
            } else {
                chainComplete?(nil)
            }
        }
        
    }
    
    class FetchRemoteModelAndImages: Node {
        
        private let conventionIdentifier: ConventionIdentifier
        private let forceRefreshRequired: ForceRefreshRequired
        private let dataStore: DataStore
        private let api: API
        private let imageDownloader: ImageDownloader
        private let eventBus: EventBus
        private let imageCache: ImagesCache
        private let clock: Clock
        private let imageRepository: ImageRepository
        
        init(
            next: Node?,
            conventionIdentifier: ConventionIdentifier,
            forceRefreshRequired: ForceRefreshRequired,
            dataStore: DataStore,
            api: API,
            imageDownloader: ImageDownloader,
            eventBus: EventBus,
            imageCache: ImagesCache,
            clock: Clock,
            imageRepository: ImageRepository
        ) {
            self.conventionIdentifier = conventionIdentifier
            self.forceRefreshRequired = forceRefreshRequired
            self.dataStore = dataStore
            self.api = api
            self.imageDownloader = imageDownloader
            self.eventBus = eventBus
            self.imageCache = imageCache
            self.clock = clock
            self.imageRepository = imageRepository
            
            super.init(next: next)
        }
        
        override func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
            super.start(progress: progress, chainComplete: chainComplete)
            
            let lastSyncTime = determineLastRefreshDate()
            api.fetchLatestData(lastSyncTime: lastSyncTime) { (response) in
                guard let response = response else {
                    self.finish(progress: progress, error: .apiError)
                    return
                }
                
                guard self.conventionIdentifier.identifier == response.conventionIdentifier else {
                    self.finish(progress: progress, error: .conventionIdentifierMismatch)
                    return
                }
                
                self.forceRefreshRequired.markForceRefreshNoLongerRequired()

                self.loadImages(response, lastSyncTime: lastSyncTime, progress: progress)
            }
        }
        
        private func loadImages(_ response: ModelCharacteristics, lastSyncTime: Date?, progress: Progress) {
            let imageDownloadRequests = response.images.changed.map(ImageDownloader.DownloadRequest.init)
            progress.completedUnitCount = 0
            progress.totalUnitCount = Int64(imageDownloadRequests.count)
            
            self.imageDownloader.downloadImages(requests: imageDownloadRequests, parentProgress: progress) {
                self.updateLocalStore(response: response, lastSyncTime: lastSyncTime)
                self.finish(progress: progress, error: nil)
            }
        }
        
        private func determineLastRefreshDate() -> Date? {
            if forceRefreshRequired.isForceRefreshRequired {
                return nil
            } else {
                return dataStore.fetchLastRefreshDate()
            }
        }
        
        private func updateLocalStore(response: ModelCharacteristics, lastSyncTime: Any?) {
            dataStore.performTransaction({ (transaction) in
                self.deleteRemovedEntities(response: response, transaction: transaction)
                self.deleteOrphanedRecords(response: response, transaction: transaction, lastSyncTime: lastSyncTime)
                self.processRemoveAllBeforeInserts(response, transaction: transaction)
                self.save(characteristics: response, in: transaction)
            })
            
            eventBus.post(DomainEvent.DataStoreChangedEvent())
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
        
        private func deleteOrphanedRecords(
            response: ModelCharacteristics,
            transaction: DataStoreTransaction,
            lastSyncTime: Any?
        ) {
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
            deleteOrphans(
                existing: dataStore.fetchAnnouncements(),
                changed: response.announcements.changed,
                delete: transaction.deleteAnnouncement
            )
        }
        
        private func deleteOrphanedEvents(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
            deleteOrphans(
                existing: dataStore.fetchEvents(),
                changed: response.events.changed,
                delete: transaction.deleteEvent
            )
        }
        
        private func deleteOrphanedKnowledgeGroups(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
            deleteOrphans(
                existing: dataStore.fetchKnowledgeGroups(),
                changed: response.knowledgeGroups.changed,
                delete: transaction.deleteKnowledgeGroup
            )
        }
        
        private func deleteOrphanedKnowledgeEntries(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
            deleteOrphans(
                existing: dataStore.fetchKnowledgeEntries(),
                changed: response.knowledgeEntries.changed,
                delete: transaction.deleteKnowledgeEntry
            )
        }
        
        private func deleteOrphanedImages(_ response: ModelCharacteristics) {
            deleteOrphans(
                existing: dataStore.fetchImages(),
                changed: response.images.changed,
                delete: imageRepository.deleteEntity
            )
        }
        
        private func deleteOrphanedDealers(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
            deleteOrphans(
                existing: dataStore.fetchDealers(),
                changed: response.dealers.changed,
                delete: transaction.deleteDealer
            )
        }
        
        private func deleteOrphanedMaps(_ response: ModelCharacteristics, _ transaction: DataStoreTransaction) {
            deleteOrphans(existing: dataStore.fetchMaps(), changed: response.maps.changed, delete: transaction.deleteMap)
        }
        
        private func deleteOrphans<T: Identifyable>(existing: [T]?, changed: [T], delete: (T.Identifier) -> Void) {
            existing?.identifiers.filter(not(changed.identifiers.contains)).forEach(delete)
        }
        
        private func processRemoveAllBeforeInserts(_ response: ModelCharacteristics, transaction: DataStoreTransaction) {
            if response.announcements.removeAllBeforeInsert {
                dataStore.fetchAnnouncements()?.identifiers.forEach(transaction.deleteAnnouncement)
            }
            
            if response.conferenceDays.removeAllBeforeInsert {
                dataStore.fetchConferenceDays()?.identifiers.forEach(transaction.deleteConferenceDay)
            }
            
            if response.rooms.removeAllBeforeInsert {
                dataStore.fetchRooms()?.identifiers.forEach(transaction.deleteRoom)
            }
            
            if response.tracks.removeAllBeforeInsert {
                dataStore.fetchTracks()?.identifiers.forEach(transaction.deleteTrack)
            }
            
            if response.knowledgeGroups.removeAllBeforeInsert {
                dataStore.fetchKnowledgeGroups()?.identifiers.forEach(transaction.deleteKnowledgeGroup)
            }
            
            if response.knowledgeEntries.removeAllBeforeInsert {
                dataStore.fetchKnowledgeEntries()?.identifiers.forEach(transaction.deleteKnowledgeEntry)
            }
            
            if response.dealers.removeAllBeforeInsert {
                dataStore.fetchDealers()?.identifiers.forEach(transaction.deleteDealer)
            }
            
            if response.images.removeAllBeforeInsert {
                dataStore.fetchImages()?.identifiers.forEach({ (identifier) in
                    transaction.deleteImage(identifier: identifier)
                    imageCache.deleteImage(identifier: identifier)
                })
            }
        }
        
    }
    
    class FetchPrivateMessagesNode: Node {
        
        private let privateMessagesController: ConcretePrivateMessagesService
        
        init(next: RefreshChain.Node?, privateMessagesController: ConcretePrivateMessagesService) {
            self.privateMessagesController = privateMessagesController
            super.init(next: next)
        }
        
        override func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
            super.start(progress: progress, chainComplete: chainComplete)
            
            privateMessagesController.refreshMessages { (_) in
                self.finish(progress: progress, error: nil)
            }
        }
        
    }
    
    class ExecuteRefreshCollaborationNode: Node {
        
        private let refreshCollaboration: RefreshCollaboration
        
        init(next: RefreshChain.Node?, refreshCollaboration: RefreshCollaboration) {
            self.refreshCollaboration = refreshCollaboration
            super.init(next: next)
        }
        
        override func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
            super.start(progress: progress, chainComplete: chainComplete)
            
            refreshCollaboration.executeCollaborativeRefreshTask(completionHandler: { (error) in
                if error != nil {
                    self.finish(progress: progress, error: .collaborationError)
                } else {
                    self.finish(progress: progress, error: nil)
                }
            })
        }
        
    }
    
    func start(progress: Progress, chainComplete: @escaping (RefreshServiceError?) -> Void) {
        first.start(progress: progress, chainComplete: chainComplete)
    }
    
}
