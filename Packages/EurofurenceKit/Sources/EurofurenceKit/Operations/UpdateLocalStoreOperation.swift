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
                try ingest(syncResponse: response, into: writingContext)
                try writingContext.save()
            } catch {
                logger.error("Failed to update local store.", metadata: ["Error": .string(String(describing: error))])
                throw error
            }
        }
        
        configuration.properties.synchronizationChangeToken = response.synchronizationToken
    }
    
    private func ingest(syncResponse: SynchronizationPayload, into managedObjectContext: NSManagedObjectContext) throws {
        try ingest(node: syncResponse.days, from: syncResponse, into: managedObjectContext, as: Day.self)
        try ingest(node: syncResponse.tracks, from: syncResponse, into: managedObjectContext, as: Track.self)
        try ingest(node: syncResponse.rooms, from: syncResponse, into: managedObjectContext, as: Room.self)
        try ingest(node: syncResponse.events, from: syncResponse, into: managedObjectContext, as: Event.self)
        try ingest(node: syncResponse.knowledgeGroups, from: syncResponse, into: managedObjectContext, as: KnowledgeGroup.self)
        try ingest(node: syncResponse.knowledgeEntries, from: syncResponse, into: managedObjectContext, as: KnowledgeEntry.self)
        try ingest(node: syncResponse.dealers, from: syncResponse, into: managedObjectContext, as: Dealer.self)
        try ingest(node: syncResponse.announcements, from: syncResponse, into: managedObjectContext, as: Announcement.self)
    }
    
    private func ingest<T: APIEntity, U: Entity & ConsumesRemoteResponse>(
        node: SynchronizationPayload.Update<T>,
        from response: SynchronizationPayload,
        into managedObjectContext: NSManagedObjectContext,
        as entityType: U.Type
    ) throws where U.RemoteObject == T {
        for changedObject in node.changed {
            let correspondingEntity = try U.entity(identifiedBy: changedObject.id, in: managedObjectContext)
            let updateContext = RemoteResponseConsumingContext(
                managedObjectContext: managedObjectContext,
                remoteObject: changedObject,
                response: response
            )
            
            try correspondingEntity.update(context: updateContext)
        }
    }
    
}
