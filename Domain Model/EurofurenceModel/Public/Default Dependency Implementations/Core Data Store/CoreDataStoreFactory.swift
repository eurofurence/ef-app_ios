import Foundation

public struct CoreDataStoreFactory: DataStoreFactory {
    
    public func makeDataStore(for conventionIdentifier: ConventionIdentifier) -> DataStore {
        return CoreDataStore(storeName: conventionIdentifier.identifier)
    }
    
}
