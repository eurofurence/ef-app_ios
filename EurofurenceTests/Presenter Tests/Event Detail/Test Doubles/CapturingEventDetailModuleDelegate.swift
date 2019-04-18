@testable import Eurofurence
import EurofurenceModel

class CapturingEventDetailModuleDelegate: EventDetailModuleDelegate {
    
    private(set) var eventToldToLeaveFeedbackFor: EventIdentifier?
    func eventDetailModuleDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        eventToldToLeaveFeedbackFor = event
    }
    
}
