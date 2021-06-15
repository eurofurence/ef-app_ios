import ComponentBase
import DealerComponent
import EurofurenceClipLogic
import EurofurenceModel
import EventDetailComponent
import XCTComponentBase
import XCTest

class EurofurenceClipRoutingTests: XCTestCase {
    
    func testUnknownContentShowsSchedule() {
        let router = FakeContentRouter()
        let clipScene = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        XCTAssertFalse(clipScene.preparedForShowingEvents)
        
        let content = SomeContentRepresentation(value: 42)
        routing.route(content)
        
        XCTAssertTrue(clipScene.preparedForShowingEvents)
        router.assertDidNotRoute(to: content)
    }
    
    func testRoutingToEventPreparesForShowingEvents() {
        let router = FakeContentRouter()
        let clipScene = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = EventContentRepresentation(identifier: EventIdentifier(""))
        routing.route(content)
        
        XCTAssertTrue(clipScene.preparedForShowingEvents)
        router.assertRouted(to: content)
    }
    
    func testRoutingToDealerPreparesForShowingDealers() {
        let router = FakeContentRouter()
        let clipScene = CapturingClipFallbackContent()
        let routing = EurofurenceClipRouting(router: router, clipScene: clipScene)
        
        let content = DealerContentRepresentation(identifier: DealerIdentifier(""))
        routing.route(content)
        
        XCTAssertTrue(clipScene.preparedForShowingDealers)
        router.assertRouted(to: content)
    }
    
    private struct SomeContentRepresentation: ContentRepresentation {
        
        var value: Int
        
    }
    
}
