import EurofurenceModel

class CapturingSessionStateObserver: SessionStateObserver {
    
    private(set) var state: EurofurenceSessionState?
    
    func sessionStateDidChange(_ newState: EurofurenceSessionState) {
        state = newState
    }
    
}
