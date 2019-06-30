@testable import Eurofurence
import EurofurenceModel

class CapturingContentRouter: ContentRouter {
    
    private(set) var resumedEvent: EventIdentifier?
    func resumeViewingEvent(identifier: EventIdentifier) {
        resumedEvent = identifier
    }
    
    private(set) var resumedDealer: DealerIdentifier?
    func resumeViewingDealer(identifier: DealerIdentifier) {
        resumedDealer = identifier
    }
    
}
