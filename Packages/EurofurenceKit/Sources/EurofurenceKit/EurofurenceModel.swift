import CoreData
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let logger: Logger
    private let properties: EurofurenceModelProperties
    private let persistentContainer: EurofurencePersistentContainer
    private let api: EurofurenceRemoteAPI
    private let conventionIdentifier: ConventionIdentifier
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init(configuration: Configuration) {
        self.logger = configuration.logger
        self.properties = configuration.properties
        self.api = EurofurenceRemoteAPI(network: configuration.network)
        self.conventionIdentifier = configuration.conventionIdentifier
        
        persistentContainer = EurofurencePersistentContainer(logger: configuration.logger)
        configuration.configure(persistentContainer: persistentContainer)
    }
    
    public func updateLocalStore() async throws {
        let response: RemoteSyncResponse
        do {
            response = try await api.executeSyncRequest(lastUpdateTime: properties.lastSyncTime)
        } catch {
            logger.error("Failed to execute sync request.", metadata: ["Error": .string(String(describing: error))])
            throw EurofurenceError.syncFailure
        }
        
        guard response.conventionIdentifier == conventionIdentifier.stringValue else {
            throw EurofurenceError.conventionIdentifierMismatch
        }
        
        try await updateLocalCache(from: response)
    }
    
    private func updateLocalCache(from response: RemoteSyncResponse) async throws {
        do {
            let writingContext = persistentContainer.newBackgroundContext()
            try await writingContext.performAsync { [writingContext] in
                for remoteDay in response.days.changed {
                    let day = try Day.entity(identifiedBy: remoteDay.Id, in: writingContext)
                    day.update(from: remoteDay)
                }
                
                for remoteTrack in response.tracks.changed {
                    let track = try Track.entity(identifiedBy: remoteTrack.Id, in: writingContext)
                    track.update(from: remoteTrack)
                }
                
                for remoteRoom in response.rooms.changed {
                    let room = try Room.entity(identifiedBy: remoteRoom.Id, in: writingContext)
                    room.update(from: remoteRoom)
                }
                
                for remoteEvent in response.events.changed {
                    let event = try Event.entity(identifiedBy: remoteEvent.Id, in: writingContext)
                    try event.update(from: remoteEvent, fullResponse: response)
                }
                
                try writingContext.save()
            }
            
            properties.lastSyncTime = response.currentDate
        } catch {
            logger.error("Failed to update local store.", metadata: ["Error": .string(String(describing: error))])
            throw error
        }
    }
    
}

// MARK: - Model Configuration

extension EurofurenceModel {
    
    public struct Configuration {
        
        public enum Environment {
            case persistent
            case memory
        }
        
        let environment: Environment
        let properties: EurofurenceModelProperties
        let logger: Logger
        let network: Network
        let conventionIdentifier: ConventionIdentifier
        
        public init(
            environment: Environment = .persistent,
            properties: EurofurenceModelProperties = AppGroupModelProperties.shared,
            network: Network = URLSessionNetwork.shared,
            logger: Logger = Logger(label: "EurofurenceKit"),
            conventionIdentifier: ConventionIdentifier = .current
        ) {
            self.environment = environment
            self.properties = properties
            self.network = network
            self.logger = logger
            self.conventionIdentifier = conventionIdentifier
        }
        
        func configure(persistentContainer: EurofurencePersistentContainer) {
            switch environment {
            case .persistent:
                persistentContainer.attachPersistentStore()
            case .memory:
                persistentContainer.attachMemoryStore()
            }
        }
        
    }
    
}
