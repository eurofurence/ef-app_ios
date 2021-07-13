import EurofurenceModel
import RouterCore

public class AuthenticateOnDemandRouteAuthenticationHandler: RouteAuthenticationHandler {
    
    private let router: Router
    private var state = State()
    
    public init(service: AuthenticationService, router: Router) {
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
        
        func userUnauthenticated() {
            handler.enterUnauthenticatedState()
        }
        
    }
    
    private class State {
        
        func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
            
        }
        
    }
    
    private class UnauthenticatedState: State {
        
        private let router: Router
        
        init(router: Router) {
            self.router = router
        }
        
        override func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
            try? router.route(LoginRouteable(completionHandler: completionHandler))
        }
        
    }
    
    private class AuthenticatedState: State {
        
        override func authenticateRouteNow(completionHandler: @escaping (Bool) -> Void) {
            completionHandler(true)
        }
        
    }
    
}
