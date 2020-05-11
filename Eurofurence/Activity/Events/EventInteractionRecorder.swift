import EurofurenceModel

public protocol EventInteractionRecorder {
    
    func makeInteraction(for event: EventIdentifier) -> Interaction?
    
}
