import Foundation

public protocol SessionStateService {

    func add(observer: SessionStateObserver)

}

public protocol SessionStateObserver {
    
    func sessionStateDidChange(_ newState: EurofurenceSessionState)
    
}
