import EurofurenceModel

protocol Interaction {
    
    func activate()
    func deactivate()
    
}

protocol EventInteractionRecorder {
    
    func makeInteraction(for event: EventIdentifier) -> Interaction?
    
}
