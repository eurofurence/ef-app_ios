import Eurofurence

class CapturingInteraction: Interaction {
    
    enum State {
        case unset
        case active
        case inactive
    }
    
    private(set) var state: State = .unset
    private(set) var donated = false
    
    func donate() {
        donated = true
    }
    
    func activate() {
        state = .active
    }
    
    func deactivate() {
        state = .inactive
    }
    
}
