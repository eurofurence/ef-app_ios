import EurofurenceModel
import KnowledgeDetailComponent
import KnowledgeGroupComponent
import RouterCore

public struct ShowKnowledgeContentFromGroupListing: KnowledgeGroupEntriesComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        try? router.route(KnowledgeEntryRouteable(identifier: identifier))
    }
    
}
