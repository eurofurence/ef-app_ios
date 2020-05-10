@testable import Eurofurence

class CapturingSuccessHaptic: SuccessHaptic {
    
    private(set) var played = false
    func play() {
        played = true
    }
    
}
