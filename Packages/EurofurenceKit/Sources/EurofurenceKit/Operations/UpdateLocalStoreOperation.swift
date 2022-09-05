import CoreData
import EurofurenceWebAPI
import Logging

struct UpdateLocalStoreOperation {
    
    private let configuration: EurofurenceModel.Configuration
    private let logger = Logger(label: "UpdateStore")
    let progress = EurofurenceModel.Progress()
    
    init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
    }
    
    func execute() async throws {
        let response = try await fetchLatestSyncResponse()
        try validateSyncResponse(response)
        try await ingestSyncResponse(response)
    }
    
    private func fetchLatestSyncResponse() async throws -> SynchronizationPayload {
        do {
            let previousChangeToken = configuration.properties.synchronizationChangeToken
            
            if logger.logLevel >= .info {
                let tokenMetatadataString = previousChangeToken?.description ?? "nil"
                logger.info("Fetching latest changes.", metadata: ["Token": .string(tokenMetatadataString)])
            }
            
            return try await configuration.api.fetchChanges(since: previousChangeToken)
        } catch {
            logger.error("Failed to execute sync request.", metadata: ["Error": .string(String(describing: error))])
            throw EurofurenceError.syncFailure
        }
    }
    
    private func validateSyncResponse(_ response: SynchronizationPayload) throws {
        guard response.conventionIdentifier == configuration.conventionIdentifier.stringValue else {
            throw EurofurenceError.conventionIdentifierMismatch
        }
    }
    
    private func ingestSyncResponse(_ response: SynchronizationPayload) async throws {
        let writingContext = configuration.persistentContainer.newBackgroundContext()
        try await writingContext.performAsync { [self, writingContext] in
            do {
                let ingester = ResponseIngester(syncResponse: response, managedObjectContext: writingContext)
                try ingester.ingest()
                
                let janitor = OrphanedEntityJanitor(managedObjectContext: writingContext)
                try janitor.cleanup()
                
                try writingContext.save()
            } catch {
                logger.error("Failed to update local store.", metadata: ["Error": .string(String(describing: error))])
                throw error
            }
        }
        
        logger.info("Finished ingesting remote changes.")
        
        configuration.properties.synchronizationChangeToken = response.synchronizationToken
        try await fetchImages(response, managedObjectContext: writingContext)
    }
    
    private func fetchImages(
        _ syncResponse: SynchronizationPayload,
        managedObjectContext: NSManagedObjectContext
    ) async throws {
        var identifiersAndHashes = [String: String]()
        
        for image in syncResponse.images.changed {
            identifiersAndHashes[image.id] = image.contentHashSha1
        }
        
        // Also include any Image entities where there is no corresponding URL.
        let fetchRequest: NSFetchRequest<EurofurenceKit.Image> = EurofurenceKit.Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cachedImageURL == nil")
        
        managedObjectContext.performAndWait { [managedObjectContext] in
            do {
                let images = try managedObjectContext.fetch(fetchRequest)
                for image in images {
                    identifiersAndHashes[image.identifier] = image.contentHashSHA1
                }
            } catch {
                logger.error(
                    "Failed to find local images to update.",
                    metadata: ["Error": .string(String(describing: error))]
                )
            }
        }
        
        try await fetchImages(identifiersAndHashes: identifiersAndHashes)
    }
    
    private func fetchImages(identifiersAndHashes: [String: String]) async throws {
        logger.info("Fetching images (count=\(identifiersAndHashes.count))")
        
        progress.update(totalUnitCount: identifiersAndHashes.count)
        
        let results: [DownloadImageResult] = await withTaskGroup(of: DownloadImageResult.self) { group in
            var results = [DownloadImageResult]()
            
            for (identifier, hash) in identifiersAndHashes {
                group.addTask {
                    await downloadImage(identifier: identifier, contentHashSHA1: hash)
                }
            }
            
            for await result in group {
                progress.updateCompletedUnitCount()
                results.append(result)
            }
            
            return results
        }
        
        let writingContext = configuration.persistentContainer.newBackgroundContext()
        try await writingContext.performAsync { [writingContext] in
            for result in results {
                guard case .success(let request) = result else { continue }
                
                let fetchRequest: NSFetchRequest<EurofurenceKit.Image> = EurofurenceKit.Image.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier == %@", request.imageIdentifier)
                
                let fetchResults = try writingContext.fetch(fetchRequest)
                for entity in fetchResults {
                    entity.cachedImageURL = request.downloadDestinationURL
                }
            }
            
            try writingContext.save()
        }
    }
    
    private enum DownloadImageResult: Sendable {
        case success(DownloadImage)
        case failure
    }
    
    private func downloadImage(identifier: String, contentHashSHA1 hash: String) async -> DownloadImageResult {
        let downloadDestination = configuration.properties.proposedURL(forImageIdentifier: identifier)
        let downloadRequest = DownloadImage(
            imageIdentifier: identifier,
            lastKnownImageContentHashSHA1: hash,
            downloadDestinationURL: downloadDestination
        )
        
        do {
            logger.info("Fetching image.", metadata: ["ID": .string(identifier)])
            try await configuration.api.downloadImage(downloadRequest)
            logger.info("Fetching image succeeded.", metadata: ["ID": .string(identifier)])
            
            return .success(downloadRequest)
        } catch {
            logger.error(
                "Failed to fetch image.",
                metadata: [
                    "ID": .string(identifier),
                    "Error": .string(String(describing: error))
                ]
            )
            return .failure
        }
    }
    
    /// Consumes a synchronization payload and ingests its contents into the persistent store.
    private struct ResponseIngester {
        
        var syncResponse: SynchronizationPayload
        var managedObjectContext: NSManagedObjectContext
        
        func ingest() throws {
            // Images are a little special. We only prepare entities for images that other objects related to (e.g.
            // Event posters and Announcement images) but still need to delete them all when requested to. We don't
            // process their changes as a node, as the Image entity itself doesn't consume remote responses - we leave
            // it to the other entities to prepare instances of its generalizations.
            if syncResponse.images.removeAllObjectsBeforeInsertion {
                try deleteAllObjects(ofType: Image.self)
            }
            
            try ingest(node: syncResponse.days, as: Day.self)
            try ingest(node: syncResponse.tracks, as: Track.self)
            try ingest(node: syncResponse.rooms, as: Room.self)
            try ingest(node: syncResponse.events, as: Event.self)
            try ingest(node: syncResponse.knowledgeGroups, as: KnowledgeGroup.self)
            try ingest(node: syncResponse.knowledgeEntries, as: KnowledgeEntry.self)
            try ingest(node: syncResponse.dealers, as: Dealer.self)
            try ingest(node: syncResponse.announcements, as: Announcement.self)
            try ingest(node: syncResponse.maps, as: Map.self)
        }
        
        private func ingest<T: APIEntity, U: Entity & ConsumesRemoteResponse>(
            node: SynchronizationPayload.Update<T>,
            as entityType: U.Type
        ) throws where U.RemoteObject == T {
            if node.removeAllObjectsBeforeInsertion {
                try deleteAllObjects(ofType: U.self)
            }
            
            for changedObject in node.changed {
                let correspondingEntity = try U.entity(identifiedBy: changedObject.id, in: managedObjectContext)
                let updateContext = RemoteResponseConsumingContext(
                    managedObjectContext: managedObjectContext,
                    remoteObject: changedObject,
                    response: syncResponse
                )
                
                try correspondingEntity.update(context: updateContext)
            }
            
            for deletedObject in node.deletedObjectIdentifiers {
                let correspondingEntity = try U.entity(identifiedBy: deletedObject, in: managedObjectContext)
                managedObjectContext.delete(correspondingEntity)
            }
        }
        
        private func deleteAllObjects<Object>(ofType entityType: Object.Type) throws where Object: NSManagedObject {
            guard let entityName = Object.entity().name else {
                fatalError("NSEntityDescription for \(Object.self) does not define an entity name")
            }

            // NOTE: An NSBatchDeleteRequest would be more performant here, but the in-memory store type does
            // not the support the command.
            let fetchRequest: NSFetchRequest<Object> = NSFetchRequest(entityName: entityName)
            fetchRequest.predicate = NSPredicate(value: true)
            
            let entities = try managedObjectContext.fetch(fetchRequest)
            for entity in entities {
                managedObjectContext.delete(entity)
            }
        }
        
    }
    
    /// Tidies up the persistent store following the ingestion of a response.
    private struct OrphanedEntityJanitor {
        
        var managedObjectContext: NSManagedObjectContext
        
        func cleanup() throws {
            try cleanupDealerCategories()
            try cleanupPanelHosts()
        }
        
        private func cleanupDealerCategories() throws {
            // Remove any categories that no longer contain a dealer.
            let emptyCategoriesFetchRequest: NSFetchRequest<DealerCategory> = DealerCategory.fetchRequest()
            emptyCategoriesFetchRequest.predicate = NSPredicate(format: "dealers.@count == 0")
            
            let emptyCategories = try managedObjectContext.fetch(emptyCategoriesFetchRequest)
            for category in emptyCategories {
                managedObjectContext.delete(category)
            }
        }
        
        private func cleanupPanelHosts() throws {
            // Remove any panel hosts no longer associated with an event.
            let notHostingEventFetchRequest: NSFetchRequest<PanelHost> = PanelHost.fetchRequest()
            notHostingEventFetchRequest.predicate = NSPredicate(format: "hostingEvents.@count == 0")
            
            let hostNoLongerHosting = try managedObjectContext.fetch(notHostingEventFetchRequest)
            for host in hostNoLongerHosting {
                managedObjectContext.delete(host)
            }
        }
        
    }
    
}
