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
    
    private(set) var didResumeViewingKnowledgeGroups = false
    func resumeViewingKnowledgeGroups() {
        didResumeViewingKnowledgeGroups = true
    }
    
    private(set) var resumedKnowledgePairing: (entry: KnowledgeEntryIdentifier, group: KnowledgeGroupIdentifier)?
    func resumeViewingKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier, parentGroup: KnowledgeGroupIdentifier) {
        resumedKnowledgePairing = (entry: knowledgeEntry, group: parentGroup)
    }
    
}
