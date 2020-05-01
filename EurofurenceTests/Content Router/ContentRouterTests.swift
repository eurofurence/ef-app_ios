import XCTest

struct AnyContentRoute {
    
    private let performRoute: (Any) -> Void
    
    init<Route>(_ route: Route) where Route: ContentRoute {
        performRoute = { (content) in
            if let content = content as? Route.Content {
                route.route(content)
            }
        }
    }
    
    func route(_ content: Any) {
        performRoute(content)
    }
    
}

class ContentRouter {
    
    private var routes = [ObjectIdentifier: AnyContentRoute]()
    
    func add<Route>(_ route: Route) where Route: ContentRoute {
        let routeIdentifier = ObjectIdentifier(Route.Content.self)
        routes[routeIdentifier] = AnyContentRoute(route)
    }
    
    func route(_ content: Any) throws {
        let routeIdentifier = ObjectIdentifier(type(of: content))
        if let route = routes[routeIdentifier] {
            route.route(content)
        } else {
            throw RouteMissing(content: content)
        }
    }
    
    struct RouteMissing: Error {
        
        var content: Any
        
    }
    
}

protocol ContentRoute {
    
    associatedtype Content
    
    func route(_ content: Content)
    
}

struct WellKnownContent: Equatable {
    
}

struct SomeOtherWellKnownContent: Equatable {
    
}

class WellKnownContentRoute: ContentRoute {
    
    typealias Content = WellKnownContent
    
    private(set) var routedContent: WellKnownContent?
    func route(_ content: WellKnownContent) {
        routedContent = content
    }
    
}

class SomeOtherWellKnownContentRoute: ContentRoute {
    
    typealias Content = SomeOtherWellKnownContent
    
    private(set) var routedContent: SomeOtherWellKnownContent?
    func route(_ content: SomeOtherWellKnownContent) {
        routedContent = content
    }
    
}

class ContentRouterTests: XCTestCase {
    
    func testWellKnownRoute() {
        let content = WellKnownContent()
        let route = WellKnownContentRoute()
        let router = ContentRouter()
        router.add(route)
        
        XCTAssertNoThrow(try router.route(content))
        
        XCTAssertEqual(content, route.routedContent)
    }
    
    func testRouteMissing() {
        let content = WellKnownContent()
        let router = ContentRouter()
        
        XCTAssertThrowsError(try router.route(content))
    }
    
    func testTwoDifferentRoutes() {
        let route = WellKnownContentRoute()
        let anotherRoute = SomeOtherWellKnownContentRoute()
        let anotherRouteContent = SomeOtherWellKnownContent()
        let router = ContentRouter()
        router.add(route)
        router.add(anotherRoute)
        
        XCTAssertNoThrow(try router.route(anotherRouteContent))
        
        XCTAssertEqual(anotherRouteContent, anotherRoute.routedContent)
    }
    
    func testTwoDifferentRoutes_InvokingFirstRoute() {
        let route = WellKnownContentRoute()
        let anotherRoute = SomeOtherWellKnownContentRoute()
        let routeContent = WellKnownContent()
        let router = ContentRouter()
        router.add(route)
        router.add(anotherRoute)
        
        XCTAssertNoThrow(try router.route(routeContent))
        
        XCTAssertEqual(routeContent, route.routedContent)
    }
    
    func testLastMostRegisteredRouteForSameContentTypeWins() {
        let content = WellKnownContent()
        let firstRoute = WellKnownContentRoute()
        let secondRoute = WellKnownContentRoute()
        let router = ContentRouter()
        router.add(firstRoute)
        router.add(secondRoute)
        
        XCTAssertNoThrow(try router.route(content))
        
        XCTAssertNil(firstRoute.routedContent)
        XCTAssertEqual(content, secondRoute.routedContent)
    }

}
