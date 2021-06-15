import ComponentBase
import EurofurenceClipLogic
import XCTest

class EurofurenceClipRoutingTests: XCTestCase {
    
    func testRoutingFailsDefersToFallbackContent() {
        let router = MutableContentRouter()
        let fallbackContent = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, fallbackContent: fallbackContent)
        
        XCTAssertFalse(fallbackContent.wasPresented)
        
        routing.route(SomeContentRepresentation(value: 42))
        
        XCTAssertTrue(fallbackContent.wasPresented)
    }
    
    func testRoutingSucceedsDoesNotDeferToFallbackContent() {
        let router = MutableContentRouter()
        let route = SomeContentRoute()
        router.add(route)
        let fallbackContent = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, fallbackContent: fallbackContent)
        
        let content = SomeContentRepresentation(value: 42)
        routing.route(content)
        
        XCTAssertFalse(fallbackContent.wasPresented)
        XCTAssertEqual(content, route.routedContent)
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
