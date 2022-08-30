import CoreData
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let configuration: Configuration
    private let persistentContainer: EurofurencePersistentContainer
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        persistentContainer = EurofurencePersistentContainer(logger: configuration.logger)
        configuration.configure(persistentContainer: persistentContainer)
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
        
        public init(environment: Environment, logger: Logger) {
            self.environment = environment
            self.logger = logger
        }
        
        func configure(persistentContainer: EurofurencePersistentContainer) {
            switch environment {
            case .persistent:
                persistentContainer.attachMemoryStore()
            case .memory:
                persistentContainer.attachPersistentStore()
            }
        }
        
    }
    
}
