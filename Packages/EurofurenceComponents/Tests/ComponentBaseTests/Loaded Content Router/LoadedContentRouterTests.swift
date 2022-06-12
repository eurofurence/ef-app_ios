import ComponentBase
import EurofurenceModel
import RouterCore
import XCTest
import XCTEurofurenceModel
import XCTRouter

class LoadedContentRouterTests: XCTestCase {
    
    func testContentLoadedForwardsRouteable() throws {
        let inner = FakeContentRouter()
        let stateService = ControllableSessionStateService()
        stateService.simulatedState = .initialized
        let router = LoadedContentRouter(stateService: stateService, destinationRoutes: inner)
        let routeable = SomeRouteable(value: 42)
        try router.route(routeable)
        
        inner.assertRouted(to: routeable)
    }
    
    func testContentUnitializedDoesNotForwardRouteable() throws {
        let inner = FakeContentRouter()
        let stateService = ControllableSessionStateService()
        stateService.simulatedState = .uninitialized
        let router = LoadedContentRouter(stateService: stateService, destinationRoutes: inner)
        let routeable = SomeRouteable(value: 42)
        try router.route(routeable)
        
        inner.assertDidNotRoute(to: routeable)
    }
    
    func testContentBecomesInitializedAfterAttemptingRoutingForwardsRouteable() throws {
        let inner = FakeContentRouter()
        let stateService = ControllableSessionStateService()
        stateService.simulatedState = .uninitialized
        let router = LoadedContentRouter(stateService: stateService, destinationRoutes: inner)
        let routeable = SomeRouteable(value: 42)
        try router.route(routeable)
        stateService.simulatedState = .initialized
        
        inner.assertRouted(to: routeable)
    }
    
    private struct SomeRouteable: Routeable {
        var value: Int
    }
    
}
