import Foundation

public protocol DataStoreFactory {
    
    func makeDataStore(for conventionIdentifier: ConventionIdentifier) -> DataStore
    
}
