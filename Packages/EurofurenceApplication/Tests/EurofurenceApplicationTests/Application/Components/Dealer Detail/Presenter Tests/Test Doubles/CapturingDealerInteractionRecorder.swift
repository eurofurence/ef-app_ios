import EurofurenceApplication
import EurofurenceModel

class CapturingDealerInteractionRecorder: DealerInteractionRecorder {
    
    private(set) var witnessedDealer: DealerIdentifier?
    private(set) var currentInteraction: CapturingInteraction?
    func makeInteraction(for dealer: DealerIdentifier) -> Interaction? {
        witnessedDealer = dealer
        
        let interaction = CapturingInteraction()
        currentInteraction = interaction
        
        return interaction
    }
    
}
