import ComponentBase
import EurofurenceModel

public struct KnowledgeGroupContentRepresentation: ContentRepresentation {
    
    public var identifier: KnowledgeGroupIdentifier
    
    public init(identifier: KnowledgeGroupIdentifier) {
        self.identifier = identifier
    }
    
}
