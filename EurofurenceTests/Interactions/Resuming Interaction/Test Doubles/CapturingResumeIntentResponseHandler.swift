@testable import Eurofurence
import EurofurenceModel

class CapturingResumeIntentResponseHandler: ContentRouter {
    
    private(set) var resumedEvent: EventIdentifier?
    func resumeViewingEvent(identifier: EventIdentifier) {
        resumedEvent = identifier
    }
    
}
