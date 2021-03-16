import Foundation

struct ContentRouteRegistery {
    
    private var routes = [ObjectIdentifier: AnyContentRoute]()
    
    mutating func add<Route>(_ route: Route) where Route: ContentRoute {
        let routeIdentifier = ObjectIdentifier(Route.Content.self)
        routes[routeIdentifier] = AnyContentRoute(route)
    }
    
    func route<Content>(for content: Content) -> AnyContentRoute? {
        let routeIdentifier = ObjectIdentifier(type(of: content))
        return routes[routeIdentifier]
    }
    
}
