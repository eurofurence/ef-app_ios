import Foundation

public class MutableContentRouter: ContentRouter {
    
    private var routeRegistry = ContentRouteRegistery()
    
    public init() {
        
    }
    
    public func add<Route>(_ route: Route) where Route: ContentRoute {
        routeRegistry.add(route)
    }
    
    public func route<Content>(_ content: Content) throws
        where Content: ContentRepresentationDescribing {
        let executor = ExecuteRoute(routeRegistry: routeRegistry)
        content.describe(to: executor)
        
        if let error = executor.error {
            throw error
        }
    }
    
    private class ExecuteRoute: ContentRepresentationRecipient {
        
        private let routeRegistry: ContentRouteRegistery
        private(set) var error: Error?
        
        init(routeRegistry: ContentRouteRegistery) {
            self.routeRegistry = routeRegistry
        }
        
        func receive<Content>(_ content: Content) where Content: ContentRepresentation {
            if let route = routeRegistry.route(for: content) {
                route.route(content)
            } else {
                error = RouteMissing(content: content)
            }
        }
        
    }
    
    private struct RouteMissing: Error {
        
        var content: Any
        
    }
    
}
