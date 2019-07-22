import EurofurenceModel

protocol DealerInteractionRecorder {
    
    func makeInteractionRecorder(for dealer: DealerIdentifier)
    
}
