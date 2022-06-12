import Foundation

class ConcreteSessionStateService: SessionStateService {

    private let forceRefreshRequired: ForceRefreshRequired
    private let userPreferences: UserPreferences
    private let dataStore: DataStore
    private var dataStoreChangedRegistration: Any?
    private var observers = [any SessionStateObserver]()
    
    init(
        eventBus: EventBus,
        forceRefreshRequired: ForceRefreshRequired,
        userPreferences: UserPreferences,
        dataStore: DataStore
    ) {
        self.forceRefreshRequired = forceRefreshRequired
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        
        dataStoreChangedRegistration = eventBus.subscribe(consumer: DataStoreChangedConsumer { [weak self] in
            self?.notifyObserversOfCurrentState()
        })
    }
    
    private var currentState: EurofurenceSessionState {
        let shouldPerformForceRefresh: Bool = forceRefreshRequired.isForceRefreshRequired
        
        guard dataStore.fetchLastRefreshDate() != nil else { return .uninitialized }

        let dataStoreStale = shouldPerformForceRefresh || userPreferences.refreshStoreOnLaunch
        return dataStoreStale ? .stale : .initialized
    }
    
    private func notifyObserversOfCurrentState() {
        let state = currentState
        for observer in observers {
            observer.sessionStateDidChange(state)
        }
    }
    
    func add(observer: any SessionStateObserver) {
        observers.append(observer)
        observer.sessionStateDidChange(currentState)
    }

}
