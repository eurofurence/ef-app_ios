import EurofurenceModel

public protocol EventDetailModuleDelegate {
    
    func eventDetailModuleDidRequestPresentationToLeaveFeedback(for event: EventIdentifier)
    
}
