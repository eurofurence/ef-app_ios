import EurofurenceModel

public class ControllableSessionStateService: SessionStateService {
    
    public init() {
        
    }
    
    public var simulatedState: EurofurenceSessionState = .uninitialized
    
    public func determineSessionState(completionHandler: @escaping (EurofurenceSessionState) -> Void) {
        completionHandler(simulatedState)
    }
    
}
