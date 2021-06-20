import RouterCore

public class AuthenticatedRoute<R>: Route where R: Route {
    
    private let route: R
    private let routeAuthenticationHandler: RouteAuthenticationHandler
    
    public init(
        route: R,
        routeAuthenticationHandler: RouteAuthenticationHandler
    ) {
        self.route = route
        self.routeAuthenticationHandler = routeAuthenticationHandler
    }
    
    public typealias Parameter = R.Parameter
    
    public func route(_ parameter: Parameter) {
        routeAuthenticationHandler.authenticateRouteNow(completionHandler: { (success) in
            if success {
                self.route.route(parameter)
            }
        })
    }
    
}
