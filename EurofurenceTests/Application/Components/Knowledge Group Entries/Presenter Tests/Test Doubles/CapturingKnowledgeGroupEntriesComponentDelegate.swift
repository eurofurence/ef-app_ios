import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingKnowledgeGroupEntriesComponentDelegate: KnowledgeGroupEntriesComponentDelegate {

    private(set) var selectedKnowledgeEntryIdentifier: KnowledgeEntryIdentifier?
    func knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        selectedKnowledgeEntryIdentifier = identifier
    }

}
