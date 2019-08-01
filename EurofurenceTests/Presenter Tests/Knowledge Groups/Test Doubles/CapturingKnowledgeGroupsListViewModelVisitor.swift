@testable import Eurofurence
import EurofurenceModel

class CapturingKnowledgeGroupsListViewModelVisitor: KnowledgeGroupsListViewModelVisitor {
    
    private(set) var visitedKnowledgeGroup: KnowledgeGroupIdentifier?
    func visit(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        visitedKnowledgeGroup = knowledgeGroup
    }
    
}
