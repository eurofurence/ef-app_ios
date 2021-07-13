import KnowledgeGroupsComponent
import KnowledgeJourney
import XCTest

class KnowledgeRouteTests: XCTestCase {
    
    func testShowsKnowledge() {
        let presentation = CapturingKnowledgePresentation()
        let route = KnowledgeRoute(presentation: presentation)
        
        XCTAssertFalse(presentation.didShowKnowledge)
        
        route.route(KnowledgeGroupsRouteable())
        
        XCTAssertTrue(presentation.didShowKnowledge)
    }
    
}
