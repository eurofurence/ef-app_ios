@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingKnowledgeGroupEntriesModuleDelegate: KnowledgeGroupEntriesModuleDelegate {

    private(set) var selectedKnowledgeEntryIdentifier: KnowledgeEntryIdentifier?
    func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        selectedKnowledgeEntryIdentifier = identifier
    }

}
