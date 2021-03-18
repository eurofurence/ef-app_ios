import ComponentBase

public class CapturingInteraction: Interaction {
    
    public enum State {
        case unset
        case active
        case inactive
    }
    
    public init() {
        
    }
    
    public private(set) var state: State = .unset
    public private(set) var donated = false
    
    public func donate() {
        donated = true
    }
    
    public func activate() {
        state = .active
    }
    
    public func deactivate() {
        state = .inactive
    }
    
}
