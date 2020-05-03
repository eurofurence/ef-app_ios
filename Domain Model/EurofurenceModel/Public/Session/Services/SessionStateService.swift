import Foundation

public protocol SessionStateService {

    func determineSessionState(completionHandler: @escaping (EurofurenceSessionState) -> Void)
    
    func add(_ observer: SessionStateServiceObserver)

}

public protocol SessionStateServiceObserver {
    
    func modelDidEnterUninitializedState()
    func modelDidEnterStaleState()
    func modelDidEnterInitializedState()
    
}
