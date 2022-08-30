import CoreData
import Logging

class EurofurencePersistentContainer: NSPersistentContainer {
    
    private let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
        super.init(name: "Eurofurence", managedObjectModel: .eurofurenceModel)
    }
    
}

// MARK: - Attaching Persistent Stores

extension EurofurencePersistentContainer {
    
    func attachPersistentStore() {
        let persistentStoreURL = FileManager.default.modelDirectory.appendingPathComponent("database.sqlite")
        let persistentStoreDescription = NSPersistentStoreDescription(url: persistentStoreURL)
        persistentStoreDescription.type = NSSQLiteStoreType
        persistentStoreDescriptions = [persistentStoreDescription]
        
        loadPersistentStores()
    }
    
    func attachMemoryStore() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        persistentStoreDescriptions = [persistentStoreDescription]
        
        loadPersistentStores()
    }
    
    private func loadPersistentStores() {
        loadPersistentStores { [logger] _, error in
            if let error = error {
                logger.error(
                    "Failed to attach persistent store",
                    metadata: ["Error": .string(String(describing: error))]
                )
            }
        }
    }
    
}
