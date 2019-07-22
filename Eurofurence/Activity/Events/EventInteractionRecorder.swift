import EurofurenceModel

protocol Interaction {
    
    func activate()
    func deactivate()
    
}

protocol EventInteractionRecorder {
    
    func makeInteractionRecorder(for event: EventIdentifier) -> Interaction?
    
}
