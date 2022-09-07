import CoreData
import EurofurenceWebAPI
import Logging

class EurofurencePersistentContainer: NSPersistentContainer {
    
    private let logger = Logger(label: "EurofurencePersistentContainer")
    private let api: EurofurenceAPI
    private let keychain: Keychain
    private let properties: EurofurenceModelProperties
    
    init(api: EurofurenceAPI, keychain: Keychain, properties: EurofurenceModelProperties) {
        self.api = api
        self.keychain = keychain
        self.properties = properties
        
        super.init(name: "Eurofurence", managedObjectModel: .eurofurenceModel)
        
        viewContext.automaticallyMergesChangesFromParent = true
        configureUserInfo(for: viewContext)
    }
    
    override func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = super.newBackgroundContext()
        configureUserInfo(for: backgroundContext)
        
        return backgroundContext
    }
    
    private func configureUserInfo(for managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.persistentContainer = self
        managedObjectContext.eurofurenceAPI = api
        managedObjectContext.keychain = keychain
        managedObjectContext.properties = properties
    }
    
}

// MARK: - Attaching Persistent Stores

extension EurofurencePersistentContainer {
    
    func attachPersistentStore(properties: EurofurenceModelProperties) {
        let modelDirectory = properties.persistentStoreDirectory
        let persistentStoreURL = modelDirectory.appendingPathComponent("database.sqlite")
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
