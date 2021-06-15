import ComponentBase
import EurofurenceClipLogic
import EurofurenceModel
import EventDetailComponent
import XCTComponentBase
import XCTest

class EurofurenceClipRoutingTests: XCTestCase {
    
    func testRoutingFailsDefersToFallbackContent() {
        let router = MutableContentRouter()
        let clipScene = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        XCTAssertFalse(clipScene.wasPresented)
        
        routing.route(SomeContentRepresentation(value: 42))
        
        XCTAssertTrue(clipScene.wasPresented)
    }
    
    func testRoutingSucceedsDoesNotDeferToFallbackContent() {
        let router = MutableContentRouter()
        let route = SomeContentRoute()
        router.add(route)
        let clipScene = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = SomeContentRepresentation(value: 42)
        routing.route(content)
        
        XCTAssertFalse(clipScene.wasPresented)
        XCTAssertEqual(content, route.routedContent)
    }
    
    func testRoutingToEventPreparesForShowingEvents() {
        let router = FakeContentRouter()
        let clipScene = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = EventContentRepresentation(identifier: EventIdentifier(""))
        routing.route(content)
        
        XCTAssertFalse(clipScene.wasPresented)
        XCTAssertTrue(clipScene.preparedForShowingEvents)
        router.assertRouted(to: content)
    }
    
    private struct SomeContentRepresentation: ContentRepresentation {
        
        var value: Int
        
    }
    
    private class SomeContentRoute: ContentRoute {
        
        private(set) var routedContent: SomeContentRepresentation?
        func route(_ content: SomeContentRepresentation) {
            routedContent = content
        }
        
    }
    
}
