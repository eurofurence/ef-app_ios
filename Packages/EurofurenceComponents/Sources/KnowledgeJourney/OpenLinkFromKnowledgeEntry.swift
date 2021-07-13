import ComponentBase
import EurofurenceModel
import KnowledgeDetailComponent
import RouterCore

public struct OpenLinkFromKnowledgeEntry: KnowledgeDetailComponentDelegate {
    
    private let router: Router
    private let linksService: ContentLinksService
    
    public init(
        router: Router,
        linksService: ContentLinksService
    ) {
        self.router = router
        self.linksService = linksService
    }
    
    public func knowledgeComponentModuleDidSelectLink(_ link: Link) {
        guard let content = linksService.lookupContent(for: link) else { return }
        
        switch content {
        case .web(let url):
            try? router.route(WebRouteable(url: url))
            
        case .externalURL(let url):
            try? router.route(ExternalApplicationRouteable(url: url))
        }
    }
    
}
