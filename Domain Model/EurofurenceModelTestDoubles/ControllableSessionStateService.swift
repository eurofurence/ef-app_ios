import EurofurenceModel

public class ControllableSessionStateService: SessionStateService {
    
    public init() {
        
    }
    
    public func determineSessionState(completionHandler: @escaping (EurofurenceSessionState) -> Void) {
        
    }
    
    private var observers = [SessionStateServiceObserver]()
    
    public func add(_ observer: SessionStateServiceObserver) {
        observers.append(observer)
    }
    
    public func enterUninitializedState() {
        observers.forEach({ $0.modelDidEnterUninitializedState() })
    }
    
    public func enterStaleState() {
        observers.forEach({ $0.modelDidEnterStaleState() })
    }
    
    public func enterInitializedState() {
        observers.forEach({ $0.modelDidEnterInitializedState() })
    }
    
}
