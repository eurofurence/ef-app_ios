import EurofurenceComponentBase

public class CapturingFailureHaptic: FailureHaptic {
    
    public init() {
        
    }
    
    public private(set) var played = false
    public func play() {
        played = true
    }
    
}
