import CoreData
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let logger: Logger
    private let persistentContainer: EurofurencePersistentContainer
    private let api: EurofurenceRemoteAPI
    private let conventionIdentifier: ConventionIdentifier
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init(configuration: Configuration) {
        self.logger = configuration.logger
        self.api = EurofurenceRemoteAPI(network: configuration.network)
        self.conventionIdentifier = configuration.conventionIdentifier
        
        persistentContainer = EurofurencePersistentContainer(logger: configuration.logger)
        configuration.configure(persistentContainer: persistentContainer)
    }
    
    public func updateLocalStore() async throws {
        let response: RemoteSyncResponse
        do {
            response = try await api.executeSyncRequest()
        } catch {
            logger.error("Failed to execute sync request.", metadata: ["Error": .string(String(describing: error))])
            throw EurofurenceError.syncFailure
        }
        
        guard response.conventionIdentifier == conventionIdentifier.stringValue else {
            throw EurofurenceError.conventionIdentifierMismatch
        }
        
        await updateLocalCache(from: response)
    }
    
    private func updateLocalCache(from response: RemoteSyncResponse) async {
        do {
            let writingContext = persistentContainer.newBackgroundContext()
            try await writingContext.performAsync { (context) in
                for remoteDay in response.days.changed {
                    let day = Day(context: context)
                    day.update(from: remoteDay)
                }
                
                for remoteTrack in response.tracks.changed {
                    let track = Track(context: context)
                    track.update(from: remoteTrack)
                }
                
                for remoteRoom in response.rooms.changed {
                    let room = Room(context: context)
                    room.update(from: remoteRoom)
                }
                
                for remoteEvent in response.events.changed {
                    let event = Event(context: context)
                    try event.update(from: remoteEvent)
                }
                
                try context.save()
            }
        } catch {
            logger.error("Failed to update local store.", metadata: ["Error": .string(String(describing: error))])
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
        let logger: Logger
        let network: Network
        let conventionIdentifier: ConventionIdentifier
        
        public init(
            environment: Environment = .persistent,
            network: Network = URLSessionNetwork.shared,
            logger: Logger,
            conventionIdentifier: ConventionIdentifier
        ) {
            self.environment = environment
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
