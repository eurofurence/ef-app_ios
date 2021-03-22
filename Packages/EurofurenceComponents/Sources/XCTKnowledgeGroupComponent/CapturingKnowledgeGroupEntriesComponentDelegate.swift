import EurofurenceModel
import KnowledgeGroupComponent

public class CapturingKnowledgeGroupEntriesComponentDelegate: KnowledgeGroupEntriesComponentDelegate {
    
    public init() {
        
    }

    public private(set) var selectedKnowledgeEntryIdentifier: KnowledgeEntryIdentifier?
    public func knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        selectedKnowledgeEntryIdentifier = identifier
    }

}
