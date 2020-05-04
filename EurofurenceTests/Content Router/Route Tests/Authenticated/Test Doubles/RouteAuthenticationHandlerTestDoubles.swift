import Eurofurence

class SuccessfulRouteAuthenticationHandler: RouteAuthenticationHandler {
    
    func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
}

class FailingRouteAuthenticationHandler: RouteAuthenticationHandler {
    
    func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(false)
    }
    
}
