import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingKnowledgeGroupsListComponentDelegate: KnowledgeGroupsListComponentDelegate {

    private(set) var capturedKnowledgeGroupToPresent: KnowledgeGroupIdentifier?
    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        capturedKnowledgeGroupToPresent = knowledgeGroup
    }
    
    private(set) var capturedKnowledgeEntryToPresent: KnowledgeEntryIdentifier?
    func knowledgeListModuleDidSelectKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier) {
        capturedKnowledgeEntryToPresent = knowledgeEntry
    }

}
