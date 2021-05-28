import EurofurenceApplication
import XCTest

class SwapToDealersTabPresentationTests: XCTestCase {
    
    func testInvokesTabNavigation() {
        let tabNavigation = CapturingTabNavigator()
        let presentation = SwapToDealersTabPresentation(tabNavigator: tabNavigation)
        
        XCTAssertFalse(tabNavigation.didMoveToTab)
        
        presentation.showDealers()
        
        XCTAssertTrue(tabNavigation.didMoveToTab)
    }
    
}
