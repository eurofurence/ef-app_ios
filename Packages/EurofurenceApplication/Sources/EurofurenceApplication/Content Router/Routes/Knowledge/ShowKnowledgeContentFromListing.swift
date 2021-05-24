import ComponentBase
import EurofurenceModel
import KnowledgeDetailComponent
import KnowledgeGroupsComponent

public struct ShowKnowledgeContentFromListing: KnowledgeGroupsListComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        try? router.route(KnowledgeGroupContentRepresentation(identifier: knowledgeGroup))
    }
    
    public func knowledgeListModuleDidSelectKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier) {
        try? router.route(KnowledgeEntryContentRepresentation(identifier: knowledgeEntry))
    }
    
}
