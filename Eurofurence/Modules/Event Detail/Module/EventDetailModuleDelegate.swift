import EurofurenceModel

protocol EventDetailModuleDelegate {
    
    func eventDetailModuleDidRequestPresentationToLeaveFeedback(for event: EventIdentifier)
    
}
