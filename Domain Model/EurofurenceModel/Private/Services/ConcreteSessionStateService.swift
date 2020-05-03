import Foundation

struct ConcreteSessionStateService: SessionStateService {

    var forceRefreshRequired: ForceRefreshRequired
    var userPreferences: UserPreferences
    var dataStore: DataStore

    func determineSessionState(completionHandler: @escaping (EurofurenceSessionState) -> Void) {
        let shouldPerformForceRefresh: Bool = forceRefreshRequired.isForceRefreshRequired
        let state: EurofurenceSessionState = {
            guard dataStore.fetchLastRefreshDate() != nil else { return .uninitialized }

            let dataStoreStale = shouldPerformForceRefresh || userPreferences.refreshStoreOnLaunch
            return dataStoreStale ? .stale : .initialized
        }()

        completionHandler(state)
    }
    
    func add(_ observer: SessionStateServiceObserver) {
        
    }

}
