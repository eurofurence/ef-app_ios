import Eurofurence
import EurofurenceModel

class CapturingEventInteractionRecorder: EventInteractionRecorder {
    
    private(set) var witnessedEvent: EventIdentifier?
    private(set) var currentInteraction: CapturingInteraction?
    func makeInteraction(for event: EventIdentifier) -> Interaction? {
        witnessedEvent = event
        
        let interaction = CapturingInteraction()
        currentInteraction = interaction
        
        return interaction
    }
    
}
