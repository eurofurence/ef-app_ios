import EurofurenceModel
import Foundation

class CapturingURLContentVisitor: URLContentVisitor {
    
    private(set) var visitedEvent: EventIdentifier?
    func visit(_ event: EventIdentifier) {
        visitedEvent = event
    }
    
    private(set) var visitedDealer: DealerIdentifier?
    func visit(_ dealer: DealerIdentifier) {
        visitedDealer = dealer
    }
    
}
