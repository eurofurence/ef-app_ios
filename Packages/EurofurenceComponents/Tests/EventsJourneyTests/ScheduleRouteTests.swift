import EventsJourney
import ScheduleComponent
import XCTest

class ScheduleRouteTests: XCTestCase {
    
    func testShowsSchedule() {
        let presentation = CapturingSchedulePresentation()
        let route = ScheduleRoute(presentation: presentation)
        
        XCTAssertFalse(presentation.didShowSchedule)
        
        route.route(ScheduleRouteable())
        
        XCTAssertTrue(presentation.didShowSchedule)
    }
    
}
