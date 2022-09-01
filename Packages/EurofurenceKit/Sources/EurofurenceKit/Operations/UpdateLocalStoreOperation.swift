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
        do {
            let writingContext = configuration.persistentContainer.newBackgroundContext()
            try await writingContext.performAsync { [self, writingContext] in
                try ingest(syncResponse: response, into: writingContext)
            }
            
            configuration.properties.lastSyncTime = response.currentDate
        } catch {
            logger.error("Failed to update local store.", metadata: ["Error": .string(String(describing: error))])
            throw error
        }
    }
    
    private func ingest(syncResponse: RemoteSyncResponse, into managedObjectContext: NSManagedObjectContext) throws {
        for remoteDay in syncResponse.days.changed {
            let day = try Day.entity(identifiedBy: remoteDay.Id, in: managedObjectContext)
            day.update(from: remoteDay)
        }
        
        for remoteTrack in syncResponse.tracks.changed {
            let track = try Track.entity(identifiedBy: remoteTrack.Id, in: managedObjectContext)
            track.update(from: remoteTrack)
        }
        
        for remoteRoom in syncResponse.rooms.changed {
            let room = try Room.entity(identifiedBy: remoteRoom.Id, in: managedObjectContext)
            room.update(from: remoteRoom)
        }
        
        for remoteEvent in syncResponse.events.changed {
            let event = try Event.entity(identifiedBy: remoteEvent.Id, in: managedObjectContext)
            try event.update(from: remoteEvent, fullResponse: syncResponse)
        }
        
        try managedObjectContext.save()
    }
    
}
