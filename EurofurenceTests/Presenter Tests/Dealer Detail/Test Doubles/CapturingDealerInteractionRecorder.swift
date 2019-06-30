@testable import Eurofurence
import EurofurenceModel

class CapturingDealerInteractionRecorder: DealerInteractionRecorder {
    
    private(set) var witnessedDealer: DealerIdentifier?
    func recordInteraction(for dealer: DealerIdentifier) {
        witnessedDealer = dealer
    }
    
}
