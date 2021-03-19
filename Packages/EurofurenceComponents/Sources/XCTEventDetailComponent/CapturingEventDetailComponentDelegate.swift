import EurofurenceModel
import EventDetailComponent

public class CapturingEventDetailComponentDelegate: EventDetailComponentDelegate {
    
    public init() {
        
    }
    
    public private(set) var eventToldToLeaveFeedbackFor: EventIdentifier?
    public func eventDetailComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        eventToldToLeaveFeedbackFor = event
    }
    
}
