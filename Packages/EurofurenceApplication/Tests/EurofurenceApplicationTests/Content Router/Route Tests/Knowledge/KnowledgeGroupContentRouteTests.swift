import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel
import XCTKnowledgeGroupComponent

class KnowledgeGroupContentRouteTests: XCTestCase {
    
    func testShowsPrimaryContentController() {
        let identifier = KnowledgeGroupIdentifier.random
        let content = KnowledgeGroupContentRepresentation(identifier: identifier)
        let contentWireframe = CapturingContentWireframe()
        let knowledgeGroupModuleProviding = StubKnowledgeGroupEntriesComponentFactory()
        let route = KnowledgeGroupContentRoute(
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
        let content = KnowledgeGroupContentRepresentation(identifier: identifier)
        let contentWireframe = CapturingContentWireframe()
        let knowledgeGroupModuleProviding = StubKnowledgeGroupEntriesComponentFactory()
        let delegate = CapturingKnowledgeGroupEntriesComponentDelegate()
        let route = KnowledgeGroupContentRoute(
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
