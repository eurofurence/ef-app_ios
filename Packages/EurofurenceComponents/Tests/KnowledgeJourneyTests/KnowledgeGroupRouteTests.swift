import EurofurenceModel
import KnowledgeGroupComponent
import KnowledgeJourney
import XCTComponentBase
import XCTest
import XCTEurofurenceModel
import XCTKnowledgeGroupComponent

class KnowledgeGroupRouteTests: XCTestCase {
    
    func testShowsPrimaryContentController() {
        let identifier = KnowledgeGroupIdentifier.random
        let content = KnowledgeGroupRouteable(identifier: identifier)
        let contentWireframe = CapturingContentWireframe()
        let knowledgeGroupModuleProviding = StubKnowledgeGroupEntriesComponentFactory()
        let route = KnowledgeGroupRoute(
            knowledgeGroupModuleProviding: knowledgeGroupModuleProviding,
            contentWireframe: contentWireframe,
            delegate: CapturingKnowledgeGroupEntriesComponentDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, knowledgeGroupModuleProviding.capturedModel)
        XCTAssertEqual(knowledgeGroupModuleProviding.stubInterface, contentWireframe.presentedPrimaryContentController)
    }
    
    func testPropogatesKnowledgeEntrySelectedEvent() {
        let identifier = KnowledgeGroupIdentifier.random
        let content = KnowledgeGroupRouteable(identifier: identifier)
        let contentWireframe = CapturingContentWireframe()
        let knowledgeGroupModuleProviding = StubKnowledgeGroupEntriesComponentFactory()
        let delegate = CapturingKnowledgeGroupEntriesComponentDelegate()
        let route = KnowledgeGroupRoute(
            knowledgeGroupModuleProviding: knowledgeGroupModuleProviding,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(content)
        
        let selectedEntry = KnowledgeEntryIdentifier.random
        knowledgeGroupModuleProviding.simulateKnowledgeEntrySelected(selectedEntry)
        
        XCTAssertEqual(selectedEntry, delegate.selectedKnowledgeEntryIdentifier)
    }

}
