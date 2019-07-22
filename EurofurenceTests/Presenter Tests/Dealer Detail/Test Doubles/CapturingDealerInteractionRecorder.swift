@testable import Eurofurence
import EurofurenceModel

class CapturingDealerInteractionRecorder: DealerInteractionRecorder {
    
    private(set) var witnessedDealer: DealerIdentifier?
    func makeInteractionRecorder(for dealer: DealerIdentifier) {
        witnessedDealer = dealer
    }
    
}
