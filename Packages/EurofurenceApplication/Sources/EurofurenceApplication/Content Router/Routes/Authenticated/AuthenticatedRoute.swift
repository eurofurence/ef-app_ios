import ComponentBase

public class AuthenticatedRoute<Route>: ContentRoute where Route: ContentRoute {
    
    private let route: Route
    private let routeAuthenticationHandler: RouteAuthenticationHandler
    
    public init(
        route: Route,
        routeAuthenticationHandler: RouteAuthenticationHandler
    ) {
        self.route = route
        self.routeAuthenticationHandler = routeAuthenticationHandler
    }
    
    public typealias Content = Route.Content
    
    public func route(_ content: Route.Content) {
        routeAuthenticationHandler.authenticateRouteNow(completionHandler: { (success) in
            if success {
                self.route.route(content)
            }
        })
    }
    
}
