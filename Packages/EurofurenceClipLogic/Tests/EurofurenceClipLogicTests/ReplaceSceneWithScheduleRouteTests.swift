import EurofurenceClipLogic
import ScheduleComponent
import XCTest

class ReplaceSceneWithScheduleRouteTests: XCTestCase {
    
    func testReplacesSceneWithEvents() {
        let scene = MockClipFallbackContent()
        let route = ReplaceSceneWithScheduleRoute(scene: scene)
        route.route(ScheduleContentRepresentation())
        
        scene.assertDisplaying(.events)
    }
    
}
