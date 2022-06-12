import EurofurenceModel

public class ControllableSessionStateService: SessionStateService {
    
    public init() {
        
    }
    
    public var simulatedState: EurofurenceSessionState = .uninitialized {
        didSet {
            for observer in observers {
                observer.sessionStateDidChange(simulatedState)
            }
        }
    }
    
    private var observers = [any SessionStateObserver]()
    
    public func add(observer: SessionStateObserver) {
        observers.append(observer)
        observer.sessionStateDidChange(simulatedState)
    }
    
}
