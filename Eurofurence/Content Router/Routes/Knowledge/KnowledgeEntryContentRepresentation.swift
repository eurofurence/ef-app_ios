import EurofurenceModel

public struct KnowledgeEntryContentRepresentation: ContentRepresentation {
    
    public var identifier: KnowledgeEntryIdentifier
    
    public init(identifier: KnowledgeEntryIdentifier) {
        self.identifier = identifier
    }
    
}
