import EurofurenceComponentBase
import EurofurenceModel

public struct OpenLinkFromKnowledgeEntry: KnowledgeDetailComponentDelegate {
    
    private let router: ContentRouter
    private let linksService: ContentLinksService
    
    public init(
        router: ContentRouter,
        linksService: ContentLinksService
    ) {
        self.router = router
        self.linksService = linksService
    }
    
    public func knowledgeComponentModuleDidSelectLink(_ link: Link) {
        guard let content = linksService.lookupContent(for: link) else { return }
        
        switch content {
        case .web(let url):
            try? router.route(WebContentRepresentation(url: url))
            
        case .externalURL(let url):
            try? router.route(ExternalApplicationContentRepresentation(url: url))
        }
    }
    
}
