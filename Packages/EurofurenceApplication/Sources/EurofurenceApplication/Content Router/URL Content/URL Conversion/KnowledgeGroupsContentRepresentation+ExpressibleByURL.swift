import Foundation
import KnowledgeGroupsComponent

// MARK: - ExpressibleByURL

extension KnowledgeGroupsContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        guard url.path.contains("KnowledgeGroups") else { return nil }
        self.init()
    }
    
}
