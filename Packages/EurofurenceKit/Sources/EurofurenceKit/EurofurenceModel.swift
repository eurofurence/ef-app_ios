import CoreData
import EurofurenceWebAPI
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let configuration: EurofurenceModel.Configuration
    
    @Published private(set) public var cloudStatus: CloudStatus = .idle
    
    public var viewContext: NSManagedObjectContext {
        configuration.persistentContainer.viewContext
    }
    
    public init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
    }
    
    public func updateLocalStore() async throws {
        let operation = UpdateLocalStoreOperation(configuration: configuration)
        cloudStatus = .updating
        
        do {
            try await operation.execute()
            cloudStatus = .updated
        } catch {
            cloudStatus = .failed
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
            
            fileprivate func configure(
                persistentContainer: EurofurencePersistentContainer,
                properties: EurofurenceModelProperties
            ) {
                switch self {
                case .persistent:
                    persistentContainer.attachPersistentStore(properties: properties)
                    
                case .memory:
                    persistentContainer.attachMemoryStore()
                }
            }
            
        }
        
        let persistentContainer: EurofurencePersistentContainer
        let properties: EurofurenceModelProperties
        let api: EurofurenceAPI
        let conventionIdentifier: ConventionIdentifier
        
        public init(
            environment: Environment = .persistent,
            properties: EurofurenceModelProperties = AppGroupModelProperties.shared,
            api: EurofurenceAPI = CIDSensitiveEurofurenceAPI.api(),
            conventionIdentifier: ConventionIdentifier = .current
        ) {
            self.persistentContainer = EurofurencePersistentContainer()
            self.properties = properties
            self.api = api
            self.conventionIdentifier = conventionIdentifier
            
            environment.configure(persistentContainer: persistentContainer, properties: properties)
        }
        
    }
    
}

// MARK: - Cloud Status

extension EurofurenceModel {
    
    public enum CloudStatus: Equatable {
        case idle
        case updating
        case updated
        case failed
    }
    
}
