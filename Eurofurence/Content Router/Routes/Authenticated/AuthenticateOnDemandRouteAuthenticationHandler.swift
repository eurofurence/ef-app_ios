import EurofurenceModel

public class AuthenticateOnDemandRouteAuthenticationHandler: RouteAuthenticationHandler {
    
    private let router: ContentRouter
    private var state = State()
    
    public init(service: AuthenticationService, router: ContentRouter) {
        self.router = router
        service.add(UpdateStateWhenAuthenticationStateChanges(handler: self))
    }
    
    public func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
        state.authenticateRouteNow(completionHandler: completionHandler)
    }
    
    private func enterAuthenticatedState() {
        state = AuthenticatedState()
    }
    
    private func enterUnauthenticatedState() {
        state = UnauthenticatedState(router: router)
    }
    
    private struct UpdateStateWhenAuthenticationStateChanges: AuthenticationStateObserver {
        
        var handler: AuthenticateOnDemandRouteAuthenticationHandler
        
        func userAuthenticated(_ user: User) {
            handler.enterAuthenticatedState()
        }
        
        func userDidLogout() {
            handler.enterUnauthenticatedState()
        }
        
        func userDidFailToLogout() {
            
        }
        
    }
    
    private class State {
        
        func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
            
        }
        
    }
    
    private class UnauthenticatedState: State {
        
        private let router: ContentRouter
        
        init(router: ContentRouter) {
            self.router = router
        }
        
        override func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
            try? router.route(LoginContentRepresentation(completionHandler: completionHandler))
        }
        
    }
    
    private class AuthenticatedState: State {
        
        override func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
            completionHandler(true)
        }
        
    }
    
}
