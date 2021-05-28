import EurofurenceApplication
import EventsJourney
import XCTest

class SwapToScheduleTabPresentationTests: XCTestCase {
    
    func testInvokesTabNavigation() {
        let tabNavigation = CapturingTabNavigator()
        let presentation = SwapToScheduleTabPresentation(tabNavigator: tabNavigation)
        
        XCTAssertFalse(tabNavigation.didMoveToTab)
        
        presentation.showSchedule()
        
        XCTAssertTrue(tabNavigation.didMoveToTab)
    }
    
}
