import ComponentBase
import EurofurenceModel

public protocol DealerInteractionRecorder {
    
    func makeInteraction(for dealer: DealerIdentifier) -> Interaction?
    
}
