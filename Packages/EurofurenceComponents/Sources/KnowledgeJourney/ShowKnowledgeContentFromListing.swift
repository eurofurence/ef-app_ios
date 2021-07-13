import EurofurenceModel
import KnowledgeDetailComponent
import KnowledgeGroupComponent
import KnowledgeGroupsComponent
import RouterCore

public struct ShowKnowledgeContentFromListing: KnowledgeGroupsListComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        try? router.route(KnowledgeGroupRouteable(identifier: knowledgeGroup))
    }
    
    public func knowledgeListModuleDidSelectKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier) {
        try? router.route(KnowledgeEntryRouteable(identifier: knowledgeEntry))
    }
    
}
