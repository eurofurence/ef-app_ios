import EurofurenceModel
import XCTEurofurenceModel

struct StubDataStoreFactory: DataStoreFactory {
    
    var conventionIdentifier: ConventionIdentifier
    var dataStore: DataStore
    
    func makeDataStore(for conventionIdentifier: ConventionIdentifier) -> DataStore {
        if self.conventionIdentifier == conventionIdentifier {
            return dataStore
        } else {
            return InMemoryDataStore()
        }
    }
    
}
