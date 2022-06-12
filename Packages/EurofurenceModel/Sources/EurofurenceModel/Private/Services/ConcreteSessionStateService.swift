import Foundation

struct ConcreteSessionStateService: SessionStateService {

    var forceRefreshRequired: ForceRefreshRequired
    var userPreferences: UserPreferences
    var dataStore: DataStore
    
    private var currentState: EurofurenceSessionState {
        let shouldPerformForceRefresh: Bool = forceRefreshRequired.isForceRefreshRequired
        
        guard dataStore.fetchLastRefreshDate() != nil else { return .uninitialized }

        let dataStoreStale = shouldPerformForceRefresh || userPreferences.refreshStoreOnLaunch
        return dataStoreStale ? .stale : .initialized
    }
    
    func add(observer: SessionStateObserver) {
        observer.sessionStateDidChange(currentState)
    }

}
