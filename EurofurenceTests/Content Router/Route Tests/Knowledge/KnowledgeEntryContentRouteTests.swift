import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class KnowledgeEntryContentRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = KnowledgeEntryIdentifier.random
        let content = KnowledgeEntryContentRepresentation(identifier: identifier)
        let knowledgeDetailModuleProviding = StubKnowledgeDetailModuleProviding()
        let contentWireframe = CapturingContentWireframe()
        let route = KnowledgeEntryContentRoute(
            knowledgeDetailModuleProviding: knowledgeDetailModuleProviding,
            contentWireframe: contentWireframe,
            delegate: CapturingKnowledgeDetailModuleDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, knowledgeDetailModuleProviding.capturedModel)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, knowledgeDetailModuleProviding.stubInterface)
    }
    
    func testPropogatesLinkSelectionDelegateEvents() {
        let identifier = KnowledgeEntryIdentifier.random
        let content = KnowledgeEntryContentRepresentation(identifier: identifier)
        let knowledgeDetailModuleProviding = StubKnowledgeDetailModuleProviding()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingKnowledgeDetailModuleDelegate()
        let route = KnowledgeEntryContentRoute(
            knowledgeDetailModuleProviding: knowledgeDetailModuleProviding,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(content)
        
        let link = Link.random
        knowledgeDetailModuleProviding.simulateLinkSelected(link)
        
        XCTAssertEqual(link, delegate.capturedLinkToOpen)
    }

}
