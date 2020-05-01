import Eurofurence
import XCTest

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
    
    // MARK: - Stub routes and content types for test
    
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

}
