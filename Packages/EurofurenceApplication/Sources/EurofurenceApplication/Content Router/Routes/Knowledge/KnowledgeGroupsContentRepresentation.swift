import EurofurenceComponentBase
import Foundation

public struct KnowledgeGroupsContentRepresentation: ContentRepresentation {
    
    public init() {
        
    }
    
}

// MARK: - ExpressibleByURL

extension KnowledgeGroupsContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        guard url.path.contains("KnowledgeGroups") else { return nil }
    }
    
}
