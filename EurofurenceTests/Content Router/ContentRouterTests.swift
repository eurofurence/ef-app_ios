import XCTest

class ContentRouter {
    
    private var route: WellKnownContentRoute?
    
    func add(_ route: WellKnownContentRoute) {
        self.route = route
    }
    
    func route(_ content: WellKnownContent) throws {
        if let route = route {
            route.route(content)
        } else {
            throw RouteMissing(content: content)
        }
    }
    
    struct RouteMissing: Error {
        
        var content: Any
        
    }
    
}

struct WellKnownContent: Equatable {
    
}

class WellKnownContentRoute {
    
    private(set) var routedContent: WellKnownContent?
    func route(_ content: WellKnownContent) {
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

}
