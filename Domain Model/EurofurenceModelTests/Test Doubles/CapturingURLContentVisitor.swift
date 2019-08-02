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
    
    private(set) var didVisitKnowledgeGroups = false
    func visitKnowledgeGroups() {
        didVisitKnowledgeGroups = true
    }
    
    private(set) var visitedKnowledgePairing: (entry: KnowledgeEntryIdentifier, group: KnowledgeGroupIdentifier)?
    func visitKnowledgeEntry(
        _ knowledgeEntry: KnowledgeEntryIdentifier,
        containedWithinGroup knowledgeGroup: KnowledgeGroupIdentifier
    ) {
        visitedKnowledgePairing = (entry: knowledgeEntry, group: knowledgeGroup)
    }
    
}
