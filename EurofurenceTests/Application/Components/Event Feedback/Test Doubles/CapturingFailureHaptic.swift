import Eurofurence

class CapturingFailureHaptic: FailureHaptic {
    
    private(set) var played = false
    func play() {
        played = true
    }
    
}
