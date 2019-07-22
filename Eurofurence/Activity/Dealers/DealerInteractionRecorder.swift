import EurofurenceModel

protocol DealerInteractionRecorder {
    
    func makeInteraction(for dealer: DealerIdentifier)
    
}
