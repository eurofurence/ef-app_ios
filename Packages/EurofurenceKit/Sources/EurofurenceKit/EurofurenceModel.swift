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
    
    public func updateLocalStore(remoteResponse: Data) async {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(EurofurenceISO8601DateFormatter.instance)
        
        do {
            let response = try decoder.decode(RemoteSyncResponse.self, from: remoteResponse)
            let writingContext = persistentContainer.newBackgroundContext()
            await writingContext.performAsync { (context) in
                for remoteDay in response.days.changed {
                    let day = Day(context: context)
                    day.update(from: remoteDay)
                }
                
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
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
