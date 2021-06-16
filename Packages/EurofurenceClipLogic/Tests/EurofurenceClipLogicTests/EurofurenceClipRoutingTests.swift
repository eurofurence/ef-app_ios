import ComponentBase
import DealerComponent
import EurofurenceClipLogic
import EurofurenceModel
import EventDetailComponent
import XCTComponentBase
import XCTest

class EurofurenceClipRoutingTests: XCTestCase {
    
    func testInitiallyDisplaysSchedule() {
        let router = FakeContentRouter()
        let clipScene = MockClipFallbackContent()
        _ = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        clipScene.assertDisplaying(.events)
    }
    
    func testUnknownContentShowsSchedule() {
        let router = FakeContentRouter()
        let clipScene = MockClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = SomeContentRepresentation(value: 42)
        routing.route(content)
        
        clipScene.assertDisplaying(.events)
        router.assertDidNotRoute(to: content)
    }
    
    func testRoutingToEventPreparesForShowingEvents() {
        let router = FakeContentRouter()
        let clipScene = MockClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = EventContentRepresentation(identifier: EventIdentifier(""))
        routing.route(content)
        
        clipScene.assertDisplaying(.events)
        router.assertRouted(to: content)
    }
    
    func testRoutingToDealerPreparesForShowingDealers() {
        let router = FakeContentRouter()
        let clipScene = MockClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = DealerContentRepresentation(identifier: DealerIdentifier(""))
        routing.route(content)
        
        clipScene.assertDisplaying(.dealers)
        router.assertRouted(to: content)
    }
    
    private struct SomeContentRepresentation: ContentRepresentation {
        
        var value: Int
        
    }
    
}
