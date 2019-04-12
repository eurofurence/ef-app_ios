@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingKnowledgeGroupsListModuleDelegate: KnowledgeGroupsListModuleDelegate {

    private(set) var capturedKnowledgeGroupToPresent: KnowledgeGroupIdentifier?
    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        capturedKnowledgeGroupToPresent = knowledgeGroup
    }

}
