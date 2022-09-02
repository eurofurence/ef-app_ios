import CoreData
import EurofurenceWebAPI
import Foundation
import Logging

public class EurofurenceModel: ObservableObject {
    
    private let configuration: EurofurenceModel.Configuration
    
    @Published public private(set) var cloudStatus: CloudStatus = .idle
    
    public var viewContext: NSManagedObjectContext {
        configuration.persistentContainer.viewContext
    }
    
    public init(configuration: EurofurenceModel.Configuration) {
        self.configuration = configuration
    }
    
    public func updateLocalStore() async throws {
        let operation = UpdateLocalStoreOperation(configuration: configuration)
        cloudStatus = .updating(progress: operation.progress)
        
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
        case updating(progress: EurofurenceModel.Progress)
        case updated
        case failed
    }
    
    public class Progress: ObservableObject, Equatable {
        
        public static func == (lhs: EurofurenceModel.Progress, rhs: EurofurenceModel.Progress) -> Bool {
            lhs === rhs
        }
        
        private let progress = Foundation.Progress()
        private var progressObservation: NSObjectProtocol?
        private var localizedDescriptionObservation: NSObjectProtocol?
        
        @Published public private(set) var fractionComplete: Double?
        
        public var localizedDescription: String {
            progress.localizedDescription
        }
        
        init() {
            progress.totalUnitCount = 0
            progress.completedUnitCount = 0
            
            progressObservation = progress.observe(\.fractionCompleted) { [weak self] progress, _ in
                self?.fractionComplete = progress.fractionCompleted
            }
        }
        
        func update(totalUnitCount: Int) {
            progress.totalUnitCount = Int64(totalUnitCount)
        }
        
        func updateCompletedUnitCount() {
            progress.completedUnitCount += 1
        }
        
    }
    
}
        
// MARK: - Fetching Entities

extension EurofurenceModel {
    
    public func announcement(identifiedBy identifier: String) throws -> Announcement {
        let fetchRequest: NSFetchRequest<Announcement> = Announcement.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        
        let results = try viewContext.fetch(fetchRequest)
        if let announcement = results.first {
            return announcement
        } else {
            throw EurofurenceError.invalidAnnouncement(identifier)
        }
    }
    
}
