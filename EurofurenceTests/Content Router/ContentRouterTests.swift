import XCTest

struct AnyContentRoute {
    
    private let performRoute: (Any) -> Bool
    
    init<Route>(_ route: Route) where Route: ContentRoute {
        performRoute = { (content) in
            if let content = content as? Route.Content {
                route.route(content)
                return true
            } else {
                return false
            }
        }
    }
    
    func route(_ content: Any) -> Bool {
        performRoute(content)
    }
    
}

class ContentRouter {
    
    private var route: AnyContentRoute?
    
    func add<Route>(_ route: Route) where Route: ContentRoute {
        self.route = AnyContentRoute(route)
    }
    
    func route(_ content: Any) throws {
        if let route = route, route.route(content) {
            
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

}
