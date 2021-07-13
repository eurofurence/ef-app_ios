import DealerComponent
import EurofurenceClipLogic
import EurofurenceModel
import EventDetailComponent
import RouterCore
import XCTComponentBase
import XCTest
import XCTRouter

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
        
        let content = SomeRouteable(value: 42)
        routing.route(content)
        
        clipScene.assertDisplaying(.events)
        router.assertRouted(to: content)
    }
    
    func testRoutingToEventPreparesForShowingEvents() {
        let router = FakeContentRouter()
        let clipScene = MockClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = EventRouteable(identifier: EventIdentifier(""))
        routing.route(content)
        
        clipScene.assertDisplaying(.events)
        router.assertRouted(to: content)
    }
    
    func testRoutingToDealerPreparesForShowingDealers() {
        let router = FakeContentRouter()
        let clipScene = MockClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = DealerRouteable(identifier: DealerIdentifier(""))
        routing.route(content)
        
        clipScene.assertDisplaying(.dealers)
        router.assertRouted(to: content)
    }
    
    func testRoutingNestedContent() {
        let router = FakeContentRouter()
        let clipScene = MockClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = DealerRouteable(identifier: DealerIdentifier(""))
        let container = Container(content: content)
        routing.route(container)
        
        clipScene.assertDisplaying(.dealers)
        router.assertRouted(to: container)
    }
    
    private struct SomeRouteable: Routeable {
        
        var value: Int
        
    }
    
    private struct Container<
        Content: Routeable
    >: Routeable, YieldsRoutable {
        
        var content: Content
        
        func yield(to recipient: YieldedRouteableRecipient) {
            recipient.receive(content)
        }
        
    }
    
}
