import CoreData
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let logger: Logger
    private let persistentContainer: EurofurencePersistentContainer
    private let api: EurofurenceRemoteAPI
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init(configuration: Configuration) {
        self.logger = configuration.logger
        self.api = EurofurenceRemoteAPI(network: configuration.network)
        
        persistentContainer = EurofurencePersistentContainer(logger: configuration.logger)
        configuration.configure(persistentContainer: persistentContainer)
    }
    
    public func updateLocalStore() async {
        do {
            let response = try await api.executeSyncRequest()
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
        
        public init(
            environment: Environment = .persistent,
            network: Network = URLSessionNetwork.shared,
            logger: Logger
        ) {
            self.environment = environment
            self.network = network
            self.logger = logger
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
