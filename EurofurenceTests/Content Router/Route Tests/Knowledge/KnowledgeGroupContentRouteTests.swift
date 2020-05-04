import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class KnowledgeGroupContentRouteTests: XCTestCase {
    
    func testShowsMasterContentController() {
        let identifier = KnowledgeGroupIdentifier.random
        let content = KnowledgeGroupContentRepresentation(identifier: identifier)
        let contentWireframe = CapturingContentWireframe()
        let knowledgeGroupModuleProviding = StubKnowledgeGroupEntriesModuleProviding()
        let route = KnowledgeGroupContentRoute(
            knowledgeGroupModuleProviding: knowledgeGroupModuleProviding,
            contentWireframe: contentWireframe,
            delegate: CapturingKnowledgeGroupEntriesModuleDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, knowledgeGroupModuleProviding.capturedModel)
        XCTAssertEqual(knowledgeGroupModuleProviding.stubInterface, contentWireframe.presentedMasterContentController)
    }
    
    func testPropogatesKnowledgeEntrySelectedEvent() {
        let identifier = KnowledgeGroupIdentifier.random
        let content = KnowledgeGroupContentRepresentation(identifier: identifier)
        let contentWireframe = CapturingContentWireframe()
        let knowledgeGroupModuleProviding = StubKnowledgeGroupEntriesModuleProviding()
        let delegate = CapturingKnowledgeGroupEntriesModuleDelegate()
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
