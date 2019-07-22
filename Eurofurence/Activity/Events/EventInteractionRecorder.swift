import EurofurenceModel

protocol EventInteractionRecorder {
    
    func makeInteraction(for event: EventIdentifier) -> Interaction?
    
}
