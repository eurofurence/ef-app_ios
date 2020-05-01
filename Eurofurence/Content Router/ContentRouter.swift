import Foundation

public class ContentRouter {
    
    private var routes = [ObjectIdentifier: AnyContentRoute]()
    
    public init() {
        
    }
    
    public func add<Route>(_ route: Route) where Route: ContentRoute {
        let routeIdentifier = ObjectIdentifier(Route.Content.self)
        routes[routeIdentifier] = AnyContentRoute(route)
    }
    
    public func route<Content>(_ content: Content) throws where Content: ContentRepresentation {
        let executor = ExecuteRoute(routes: routes)
        content.describe(to: executor)
        
        if let error = executor.error {
            throw error
        }
    }
    
    private class ExecuteRoute: ContentRepresentationRecipient {
        
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
    
    private struct RouteMissing: Error {
        
        var content: Any
        
    }
    
}
