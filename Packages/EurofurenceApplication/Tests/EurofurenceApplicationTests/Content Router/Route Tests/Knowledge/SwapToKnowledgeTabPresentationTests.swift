import EurofurenceApplication
import KnowledgeJourney
import XCTest

class SwapToKnowledgeTabPresentationTests: XCTestCase {
    
    func testInvokesTabNavigation() {
        let tabNavigation = CapturingTabNavigator()
        let presentation = SwapToKnowledgeTabPresentation(tabNavigator: tabNavigation)
        
        XCTAssertFalse(tabNavigation.didMoveToTab)
        
        presentation.showKnowledge()
        
        XCTAssertTrue(tabNavigation.didMoveToTab)
    }
    
}
