import EurofurenceComponentBase
import EurofurenceModel

public struct ShowKnowledgeContentFromGroupListing: KnowledgeGroupEntriesComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        try? router.route(KnowledgeEntryContentRepresentation(identifier: identifier))
    }
    
}
