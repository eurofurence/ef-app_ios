import Eurofurence

class CapturingInteraction: Interaction {
    
    enum State {
        case unset
        case active
        case inactive
    }
    
    private(set) var state: State = .unset
    
    func activate() {
        state = .active
    }
    
    func deactivate() {
        state = .inactive
    }
    
}
