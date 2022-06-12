import Foundation

public protocol SessionStateService {

    func add(observer: any SessionStateObserver)

}

public protocol SessionStateObserver {
    
    func sessionStateDidChange(_ newState: EurofurenceSessionState)
    
}
