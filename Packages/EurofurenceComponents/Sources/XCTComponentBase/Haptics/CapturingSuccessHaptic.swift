import ComponentBase

public class CapturingSuccessHaptic: SuccessHaptic {
    
    public init() {
        
    }
    
    public private(set) var played = false
    public func play() {
        played = true
    }
    
}
