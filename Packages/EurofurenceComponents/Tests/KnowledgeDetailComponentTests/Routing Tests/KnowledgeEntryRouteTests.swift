import EurofurenceModel
import KnowledgeDetailComponent
import XCTComponentBase
import XCTest
import XCTEurofurenceModel
import XCTKnowledgeDetailComponent

class KnowledgeEntryRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = KnowledgeEntryIdentifier.random
        let content = KnowledgeEntryRouteable(identifier: identifier)
        let knowledgeDetailComponentFactory = StubKnowledgeDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = KnowledgeEntryRoute(
            knowledgeDetailComponentFactory: knowledgeDetailComponentFactory,
            contentWireframe: contentWireframe,
            delegate: CapturingKnowledgeDetailComponentDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, knowledgeDetailComponentFactory.capturedModel)
        XCTAssertEqual(contentWireframe.replacedDetailContentController, knowledgeDetailComponentFactory.stubInterface)
    }
    
    func testPropogatesLinkSelectionDelegateEvents() {
        let identifier = KnowledgeEntryIdentifier.random
        let content = KnowledgeEntryRouteable(identifier: identifier)
        let knowledgeDetailComponentFactory = StubKnowledgeDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingKnowledgeDetailComponentDelegate()
        let route = KnowledgeEntryRoute(
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
