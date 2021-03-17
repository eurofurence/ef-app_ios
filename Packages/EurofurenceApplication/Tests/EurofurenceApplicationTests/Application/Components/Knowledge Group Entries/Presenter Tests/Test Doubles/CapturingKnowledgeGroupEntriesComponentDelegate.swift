import EurofurenceApplication
import EurofurenceModel
import Foundation
import XCTEurofurenceModel

class CapturingKnowledgeGroupEntriesComponentDelegate: KnowledgeGroupEntriesComponentDelegate {

    private(set) var selectedKnowledgeEntryIdentifier: KnowledgeEntryIdentifier?
    func knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        selectedKnowledgeEntryIdentifier = identifier
    }

}
