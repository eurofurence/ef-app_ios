import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class KnowledgeEntryContentRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = KnowledgeEntryIdentifier.random
        let content = KnowledgeEntryContentRepresentation(identifier: identifier)
        let knowledgeDetailComponentFactory = StubKnowledgeDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = KnowledgeEntryContentRoute(
            knowledgeDetailComponentFactory: knowledgeDetailComponentFactory,
            contentWireframe: contentWireframe,
            delegate: CapturingKnowledgeDetailComponentDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, knowledgeDetailComponentFactory.capturedModel)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, knowledgeDetailComponentFactory.stubInterface)
    }
    
    func testPropogatesLinkSelectionDelegateEvents() {
        let identifier = KnowledgeEntryIdentifier.random
        let content = KnowledgeEntryContentRepresentation(identifier: identifier)
        let knowledgeDetailComponentFactory = StubKnowledgeDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingKnowledgeDetailComponentDelegate()
        let route = KnowledgeEntryContentRoute(
            knowledgeDetailComponentFactory: knowledgeDetailComponentFactory,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(content)
        
        let link = Link.random
        knowledgeDetailComponentFactory.simulateLinkSelected(link)
        
        XCTAssertEqual(link, delegate.capturedLinkToOpen)
    }

}
