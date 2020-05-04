import EurofurenceModel

public struct ShowKnowledgeContentFromGroupListing: KnowledgeGroupEntriesModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        try? router.route(KnowledgeEntryContentRepresentation(identifier: identifier))
    }
    
}
