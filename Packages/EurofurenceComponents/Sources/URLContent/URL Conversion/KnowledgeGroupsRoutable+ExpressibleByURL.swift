import Foundation
import KnowledgeGroupsComponent
import URLRouteable

extension KnowledgeGroupsRouteable: ExpressibleByURL {
    
    public init?(url: URL) {
        guard url.path.contains("KnowledgeGroups") else { return nil }
        self.init()
    }
    
}
