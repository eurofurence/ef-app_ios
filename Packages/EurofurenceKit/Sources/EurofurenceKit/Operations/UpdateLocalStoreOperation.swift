import CoreData
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
    
    private func fetchLatestSyncResponse() async throws -> RemoteSyncResponse {
        do {
            let lastSyncTime = configuration.properties.lastSyncTime
            return try await configuration.api.executeSyncRequest(lastUpdateTime: lastSyncTime)
        } catch {
            logger.error("Failed to execute sync request.", metadata: ["Error": .string(String(describing: error))])
            throw EurofurenceError.syncFailure
        }
    }
    
    private func validateSyncResponse(_ response: RemoteSyncResponse) throws {
        guard response.conventionIdentifier == configuration.conventionIdentifier.stringValue else {
            throw EurofurenceError.conventionIdentifierMismatch
        }
    }
    
    private func ingestSyncResponse(_ response: RemoteSyncResponse) async throws {
        let writingContext = configuration.persistentContainer.newBackgroundContext()
        try await writingContext.performAsync { [self, writingContext] in
            do {
                try ingest(syncResponse: response, into: writingContext)
            } catch {
                logger.error("Failed to update local store.", metadata: ["Error": .string(String(describing: error))])
                throw error
            }
        }
        
        configuration.properties.lastSyncTime = response.currentDate
    }
    
    private func ingest(syncResponse: RemoteSyncResponse, into managedObjectContext: NSManagedObjectContext) throws {
        for remoteDay in syncResponse.days.changed {
            let day = try Day.entity(identifiedBy: remoteDay.id, in: managedObjectContext)
            let context = RemoteResponseConsumingContext(
                managedObjectContext: managedObjectContext,
                remoteObject: remoteDay,
                response: syncResponse
            )
            
            try day.update(context: context)
        }
        
        for remoteTrack in syncResponse.tracks.changed {
            let track = try Track.entity(identifiedBy: remoteTrack.id, in: managedObjectContext)
            let context = RemoteResponseConsumingContext(
                managedObjectContext: managedObjectContext,
                remoteObject: remoteTrack,
                response: syncResponse
            )
            
            try track.update(context: context)
        }
        
        for remoteRoom in syncResponse.rooms.changed {
            let room = try Room.entity(identifiedBy: remoteRoom.id, in: managedObjectContext)
            let context = RemoteResponseConsumingContext(
                managedObjectContext: managedObjectContext,
                remoteObject: remoteRoom,
                response: syncResponse
            )
            
            try room.update(context: context)
        }
        
        for remoteEvent in syncResponse.events.changed {
            let event = try Event.entity(identifiedBy: remoteEvent.id, in: managedObjectContext)
            
            let context = RemoteResponseConsumingContext(
                managedObjectContext: managedObjectContext,
                remoteObject: remoteEvent,
                response: syncResponse
            )
            
            try event.update(context: context)
        }
        
        for remoteKnowledgeGroup in syncResponse.knowledgeGroups.changed {
            let knowledgeGroup = try KnowledgeGroup.entity(
                identifiedBy: remoteKnowledgeGroup.id,
                in: managedObjectContext
            )
            
            let context = RemoteResponseConsumingContext(
                managedObjectContext: managedObjectContext,
                remoteObject: remoteKnowledgeGroup,
                response: syncResponse
            )
            
            try knowledgeGroup.update(context: context)
        }
        
        for remoteKnowledgeEntry in syncResponse.knowledgeEntries.changed {
            let knowledgeEntry = try KnowledgeEntry.entity(
                identifiedBy: remoteKnowledgeEntry.id,
                in: managedObjectContext
            )
            
            let context = RemoteResponseConsumingContext(
                managedObjectContext: managedObjectContext,
                remoteObject: remoteKnowledgeEntry,
                response: syncResponse
            )
            
            try knowledgeEntry.update(context: context)
        }
        
        try managedObjectContext.save()
    }
    
}
