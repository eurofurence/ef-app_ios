import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class AuthenticatedRouteTests: XCTestCase {
    
    func testLoggedInPassesContent() throws {
        let router = MutableContentRouter()
        let content = SampleContent(value: .random)
        let route = SampleContentRoute()
        let authenticatedRoute = AuthenticatedRoute(
            route: route,
            routeAuthenticationHandler: SuccessfulRouteAuthenticationHandler()
        )
        
        router.add(authenticatedRoute)
        try router.route(content)
        
        XCTAssertEqual(content, route.capturedContent)
    }
    
    func testAuthenticationFailsDoesNotPassContent() throws {
        let router = MutableContentRouter()
        let content = SampleContent(value: .random)
        let route = SampleContentRoute()
        let authenticatedRoute = AuthenticatedRoute(
            route: route,
            routeAuthenticationHandler: FailingRouteAuthenticationHandler()
        )
        
        router.add(authenticatedRoute)
        try router.route(content)
        
        XCTAssertNil(route.capturedContent)
    }
    
    func testAuthenticationSuccessPassesContent() throws {
        let router = MutableContentRouter()
        let content = SampleContent(value: .random)
        let route = SampleContentRoute()
        let authenticatedRoute = AuthenticatedRoute(
            route: route,
            routeAuthenticationHandler: SuccessfulRouteAuthenticationHandler()
        )
        
        router.add(authenticatedRoute)
        try router.route(content)
        
        XCTAssertEqual(content, route.capturedContent)
    }
    
}

private struct SampleContent: ContentRepresentation {
    
    var value: Int
    
}

private class SampleContentRoute: ContentRoute {
    
    typealias Content = SampleContent
    
    private(set) var capturedContent: SampleContent?
    func route(_ content: SampleContent) {
        capturedContent = content
    }
    
}
