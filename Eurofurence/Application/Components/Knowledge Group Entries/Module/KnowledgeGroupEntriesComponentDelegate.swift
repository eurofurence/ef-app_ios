import EurofurenceModel
import Foundation

public protocol KnowledgeGroupEntriesComponentDelegate {

    func knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(
        identifier: KnowledgeEntryIdentifier
    )

}
