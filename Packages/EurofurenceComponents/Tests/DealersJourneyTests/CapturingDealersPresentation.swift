import DealersJourney

class CapturingDealersPresentation: DealersPresentation {
    
    private(set) var didShowDealers = false
    func showDealers() {
        didShowDealers = true
    }
    
}
