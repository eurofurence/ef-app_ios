@testable import Eurofurence
import EurofurenceModel

class CapturingContentRouter: ContentRouter {
    
    private(set) var resumedEvent: EventIdentifier?
    func resumeViewingEvent(identifier: EventIdentifier) {
        resumedEvent = identifier
    }
    
}
