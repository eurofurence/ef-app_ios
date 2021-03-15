import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class OpenLinkFromKnowledgeEntryTests: XCTestCase {
    
    func testWebLink() {
        let url = URL.random
        assertLinkContent(
            .web(url),
            routesTo: WebContentRepresentation(url: url)
        )
    }
    
    func testExternalURL() {
        let url = URL.random
        assertLinkContent(
            .externalURL(url),
            routesTo: ExternalApplicationContentRepresentation(url: url)
        )
    }
    
    private func assertLinkContent<Content>(
        _ linkContent: LinkContentLookupResult,
        routesTo expected: Content,
        _ line: UInt = #line
    ) where Content: ContentRepresentation {
        let link = Link.random
        let linksService = StubContentLinksService()
        linksService.stubContent(linkContent, for: link)
        let router = FakeContentRouter()
        let navigator = OpenLinkFromKnowledgeEntry(router: router, linksService: linksService)
        navigator.knowledgeComponentModuleDidSelectLink(link)
        
        router.assertRouted(to: expected, line: line)
    }

}
