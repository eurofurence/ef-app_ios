import ComponentBase
import EurofurenceModel
import RouterCore

public struct KnowledgeEntryRouteable: Routeable {
    
    public var identifier: KnowledgeEntryIdentifier
    
    public init(identifier: KnowledgeEntryIdentifier) {
        self.identifier = identifier
    }
    
}
