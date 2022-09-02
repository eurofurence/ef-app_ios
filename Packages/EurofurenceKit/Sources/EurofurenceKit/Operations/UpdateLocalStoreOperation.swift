import CoreData
import EurofurenceWebAPI
import Logging

struct UpdateLocalStoreOperation {
    
    private let configuration: EurofurenceModel.Configuration
    private let logger = Logger(label: "UpdateStore")
    
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
                try writingContext.save()
            } catch {
                logger.error("Failed to update local store.", metadata: ["Error": .string(String(describing: error))])
                throw error
            }
        }
        
        logger.info("Finished ingesting remote changes.")
        
        configuration.properties.synchronizationChangeToken = response.synchronizationToken
        try await fetchImages(response)
    }
    
    private func fetchImages(_ syncResponse: SynchronizationPayload) async throws {
        let imagesDirectory = configuration.properties.imagesDirectory
        
        enum DownloadImageResult: Sendable {
            case success(DownloadImageRequest)
            case failure
        }
        
        logger.info("Fetching images (count=\(syncResponse.images.changed))")
        
        let results: [DownloadImageResult] = await withTaskGroup(of: DownloadImageResult.self) { [logger] group in
            var results = [DownloadImageResult]()
            
            for image in syncResponse.images.changed {
                let imageDestinationURL = imagesDirectory.appendingPathComponent(image.id)
                
                group.addTask {
                    let fetchRequest = DownloadImageRequest(
                        imageIdentifier: image.id,
                        lastKnownImageContentHashSHA1: image.contentHashSha1,
                        downloadDestinationURL: imageDestinationURL
                    )
                    
                    do {
                        logger.info("Fetching image.", metadata: ["ID": .string(image.id)])
                        try await configuration.api.downloadImage(fetchRequest)
                        logger.info("Fetching image succeeded.", metadata: ["ID": .string(image.id)])
                        
                        return .success(fetchRequest)
                    } catch {
                        logger.error(
                            "Failed to fetch image.",
                            metadata: [
                                "ID": .string(image.id),
                                "Error": .string(String(describing: error))
                            ]
                        )
                        return .failure
                    }
                }
            }
            
            for await result in group {
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
                fetchRequest.fetchLimit = 1
                
                let fetchResults = try writingContext.fetch(fetchRequest)
                guard let entity = fetchResults.first else { continue }
                
                entity.cachedImageURL = request.downloadDestinationURL
            }
            
            try writingContext.save()
        }
    }
    
    private struct ResponseIngester {
        
        var syncResponse: SynchronizationPayload
        var managedObjectContext: NSManagedObjectContext
        
        func ingest() throws {
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
            for changedObject in node.changed {
                let correspondingEntity = try U.entity(identifiedBy: changedObject.id, in: managedObjectContext)
                let updateContext = RemoteResponseConsumingContext(
                    managedObjectContext: managedObjectContext,
                    remoteObject: changedObject,
                    response: syncResponse
                )
                
                try correspondingEntity.update(context: updateContext)
            }
        }
        
    }
    
}
