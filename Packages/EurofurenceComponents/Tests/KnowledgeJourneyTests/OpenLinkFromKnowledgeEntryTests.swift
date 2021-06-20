import ComponentBase
import EurofurenceModel
import KnowledgeJourney
import RouterCore
import XCTest
import XCTEurofurenceModel
import XCTRouter

class OpenLinkFromKnowledgeEntryTests: XCTestCase {
    
    func testWebLink() {
        let url = URL.random
        assertLinkContent(
            .web(url),
            routesTo: WebRouteable(url: url)
        )
    }
    
    func testExternalURL() {
        let url = URL.random
        assertLinkContent(
            .externalURL(url),
            routesTo: ExternalApplicationRouteable(url: url)
        )
    }
    
    private func assertLinkContent<Content>(
        _ linkContent: LinkContentLookupResult,
        routesTo expected: Content,
        _ line: UInt = #line
    ) where Content: Routeable {
        let link = Link.random
        let linksService = StubContentLinksService()
        linksService.stubContent(linkContent, for: link)
        let router = FakeContentRouter()
        let navigator = OpenLinkFromKnowledgeEntry(router: router, linksService: linksService)
        navigator.knowledgeComponentModuleDidSelectLink(link)
        
        router.assertRouted(to: expected, line: line)
    }

}
