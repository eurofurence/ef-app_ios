@testable import Eurofurence
import EurofurenceModel

class CapturingResumeIntentResponseHandler: ResumeInteractionResponseHandler {
    
    private(set) var resumedEvent: EventIdentifier?
    func resumeViewingEvent(identifier: EventIdentifier) {
        resumedEvent = identifier
    }
    
    private(set) var didResumeCollectThemAllIntent = false
    func resumeCollectThemAll() {
        didResumeCollectThemAllIntent = true
    }
    
}
