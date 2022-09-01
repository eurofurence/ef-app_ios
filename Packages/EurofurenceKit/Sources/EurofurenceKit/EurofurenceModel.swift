import CoreData
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let configuration: EurofurenceModel.Configuration
    
    public var viewContext: NSManagedObjectContext {
        configuration.persistentContainer.viewContext
    }
    
    public init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
    }
    
    public func updateLocalStore() async throws {
        let operation = UpdateLocalStoreOperation(configuration: configuration)
        try await operation.execute()
    }
    
}

// MARK: - Model Configuration

extension EurofurenceModel {
    
    public struct Configuration {
        
        public enum Environment {
            
            case persistent
            case memory
            
            fileprivate func configure(persistentContainer: EurofurencePersistentContainer) {
                switch self {
                case .persistent:
                    persistentContainer.attachPersistentStore()
                case .memory:
                    persistentContainer.attachMemoryStore()
                }
            }
            
        }
        
        let persistentContainer: EurofurencePersistentContainer
        let properties: EurofurenceModelProperties
        let logger: Logger
        let api: EurofurenceRemoteAPI
        let network: Network
        let conventionIdentifier: ConventionIdentifier
        
        public init(
            environment: Environment = .persistent,
            properties: EurofurenceModelProperties = AppGroupModelProperties.shared,
            network: Network = URLSessionNetwork.shared,
            logger: Logger = Logger(label: "EurofurenceKit"),
            conventionIdentifier: ConventionIdentifier = .current
        ) {
            self.persistentContainer = EurofurencePersistentContainer(logger: logger)
            self.properties = properties
            self.network = network
            self.logger = logger
            self.conventionIdentifier = conventionIdentifier
            self.api = EurofurenceRemoteAPI(network: network)
            
            environment.configure(persistentContainer: persistentContainer)
        }
        
    }
    
}
