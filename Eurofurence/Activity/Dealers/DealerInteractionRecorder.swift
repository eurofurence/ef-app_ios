import EurofurenceModel

protocol DealerInteractionRecorder {
    
    func recordInteraction(for dealer: DealerIdentifier)
    
}
