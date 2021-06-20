import ComponentBase
import EurofurenceApplication
import EurofurenceModel
import RouterCore
import XCTest
import XCTEurofurenceModel

class AuthenticatedRouteTests: XCTestCase {
    
    func testLoggedInPassesContent() throws {
        var router = Routes()
        let content = SampleContent(value: .random)
        let route = SampleContentRoute()
        let authenticatedRoute = AuthenticatedRoute(
            route: route,
            routeAuthenticationHandler: SuccessfulRouteAuthenticationHandler()
        )
        
        router.install(authenticatedRoute)
        try router.route(content)
        
        XCTAssertEqual(content, route.capturedContent)
    }
    
    func testAuthenticationFailsDoesNotPassContent() throws {
        var router = Routes()
        let content = SampleContent(value: .random)
        let route = SampleContentRoute()
        let authenticatedRoute = AuthenticatedRoute(
            route: route,
            routeAuthenticationHandler: FailingRouteAuthenticationHandler()
        )
        
        router.install(authenticatedRoute)
        try router.route(content)
        
        XCTAssertNil(route.capturedContent)
    }
    
    func testAuthenticationSuccessPassesContent() throws {
        var router = Routes()
        let content = SampleContent(value: .random)
        let route = SampleContentRoute()
        let authenticatedRoute = AuthenticatedRoute(
            route: route,
            routeAuthenticationHandler: SuccessfulRouteAuthenticationHandler()
        )
        
        router.install(authenticatedRoute)
        try router.route(content)
        
        XCTAssertEqual(content, route.capturedContent)
    }
    
}

private struct SampleContent: Routeable {
    
    var value: Int
    
}

private class SampleContentRoute: Route {
    
    typealias Content = SampleContent
    
    private(set) var capturedContent: SampleContent?
    func route(_ content: SampleContent) {
        capturedContent = content
    }
    
}
