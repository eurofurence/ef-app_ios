import ComponentBase
import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase

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
