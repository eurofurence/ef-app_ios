import EurofurenceModel
import RouterCore

public struct KnowledgeGroupRouteable: Routeable {
    
    public var identifier: KnowledgeGroupIdentifier
    
    public init(identifier: KnowledgeGroupIdentifier) {
        self.identifier = identifier
    }
    
}
