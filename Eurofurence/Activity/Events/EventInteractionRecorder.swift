import EurofurenceModel

protocol EventInteractionRecorder {
    
    func makeInteractionRecorder(for event: EventIdentifier)
    
}
