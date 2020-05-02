public protocol RouteAuthenticationHandler {
    
    func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void)
    
}
