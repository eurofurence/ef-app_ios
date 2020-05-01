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
    
    func route<Content>(_ content: Content) throws where Content: ContentRepresentation {
        let executor = ExecuteRoute(routes: routes)
        content.describe(to: executor)
        
        if let error = executor.error {
            throw error
        }
    }
    
    class ExecuteRoute: ContentRepresentationRecipient {
        
        private let routes: [ObjectIdentifier: AnyContentRoute]
        private(set) var error: Error?
        
        init(routes: [ObjectIdentifier: AnyContentRoute]) {
            self.routes = routes
        }
        
        func receive<Content>(_ content: Content) where Content: ContentRepresentation {
            let routeIdentifier = ObjectIdentifier(type(of: content))
            if let route = routes[routeIdentifier] {
                route.route(content)
            } else {
                error = RouteMissing(content: content)
            }
        }
        
    }
    
    struct RouteMissing: Error {
        
        var content: Any
        
    }
    
}

protocol ContentRoute {
    
    associatedtype Content: ContentRepresentation
    
    func route(_ content: Content)
    
}

protocol ContentRepresentation: Equatable {
    
    func describe(to recipient: ContentRepresentationRecipient)
    
}

extension ContentRepresentation {
    
    func describe(to recipient: ContentRepresentationRecipient) {
        recipient.receive(self)
    }
    
}

protocol ContentRepresentationRecipient {
    
    func receive<Content>(_ content: Content) where Content: ContentRepresentation
    
}

struct WellKnownContent: ContentRepresentation {
    
}

struct SomeOtherWellKnownContent: ContentRepresentation {
    
}

struct WrapperContent<Content>: ContentRepresentation where Content: ContentRepresentation {
    
    var inner: Content
    
    func describe(to recipient: ContentRepresentationRecipient) {
        recipient.receive(inner)
    }
    
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
    
    func testComplexContentPassedToExpectedRoute() {
        let content = WellKnownContent()
        let complexContent = WrapperContent(inner: content)
        let route = WellKnownContentRoute()
        let router = ContentRouter()
        router.add(route)
        
        XCTAssertNoThrow(try router.route(complexContent))
        
        XCTAssertEqual(content, route.routedContent)
    }

}
