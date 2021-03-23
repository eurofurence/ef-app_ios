Import KnowledgeGroupsComponent
import EurofurenceModel

class CapturingKnowledgeGroupsListViewModelVisitor: KnowledgeGroupsListViewModelVisitor {
    
    private(set) var visitedKnowledgeGroup: KnowledgeGroupIdentifier?
    func visit(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        visitedKnowledgeGroup = knowledgeGroup
    }
    
    private(set) var visitedKnowledgeEntry: KnowledgeEntryIdentifier?
    func visit(_ knowledgeEntry: KnowledgeEntryIdentifier) {
        visitedKnowledgeEntry = knowledgeEntry
    }
    
}
