import EurofurenceApplication

class CapturingSuccessHaptic: SuccessHaptic {
    
    private(set) var played = false
    func play() {
        played = true
    }
    
}
