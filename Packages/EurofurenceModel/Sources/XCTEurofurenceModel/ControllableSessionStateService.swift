import EurofurenceModel

public class ControllableSessionStateService: SessionStateService {
    
    public init() {
        
    }
    
    public var simulatedState: EurofurenceSessionState = .uninitialized
    
    public func add(observer: SessionStateObserver) {
        observer.sessionStateDidChange(simulatedState)
    }
    
}
