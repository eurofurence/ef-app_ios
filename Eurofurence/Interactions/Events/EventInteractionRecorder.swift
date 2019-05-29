import EurofurenceModel

protocol EventInteractionRecorder {
    
    func recordInteraction(for event: EventIdentifier)
    
}
