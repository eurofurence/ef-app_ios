import EurofurenceModel

public protocol EventDetailComponentDelegate {
    
    func eventDetailComponentDidRequestPresentationToLeaveFeedback(
        for event: EventIdentifier
    )
    
}
