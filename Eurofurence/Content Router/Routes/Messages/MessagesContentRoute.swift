import EurofurenceModel

public class MessagesContentRoute {
    
    private unowned let router: ContentRouter
    private let messagesModuleProviding: MessagesModuleProviding
    private let contentWireframe: ContentWireframe
    private let delegate: MessagesModuleDelegate
    
    fileprivate var state: State = State()
    
    public init(
        router: ContentRouter,
        messagesModuleProviding: MessagesModuleProviding,
        contentWireframe: ContentWireframe,
        authenticationService: AuthenticationService,
        delegate: MessagesModuleDelegate
    ) {
        self.router = router
        self.messagesModuleProviding = messagesModuleProviding
        self.contentWireframe = contentWireframe
        self.delegate = delegate
        
        authenticationService.add(ChangeStateOnModelEvent(route: self))
    }
    
    private func showMessagesModule() {
        let contentController = messagesModuleProviding.makeMessagesModule(delegate)
        contentWireframe.presentMasterContentController(contentController)
    }
    
}

// MARK: - ContentRoute

extension MessagesContentRoute: ContentRoute {
    
    public typealias Content = MessagesContentRepresentation
    
    public func route(_ content: MessagesContentRepresentation) {
        state.process(content)
    }
    
}

// MARK: - Managing state transitions

private extension MessagesContentRoute {
    
    func enterAuthenticatedState() {
        state = AuthenticatedState(route: self)
    }
    
    func enterUnauthenticatedState() {
        state = UnauthenticatedState(route: self, router: router)
    }
    
    struct ChangeStateOnModelEvent: AuthenticationStateObserver {
        
        var route: MessagesContentRoute
        
        func userDidLogin(_ user: User) {
            route.enterAuthenticatedState()
        }
        
        func userDidLogout() {
            route.enterUnauthenticatedState()
        }
        
        func userDidFailToLogout() {
            
        }
        
    }
    
    class State {
        
        func process(_ content: MessagesContentRepresentation) {
            
        }
        
    }
    
    class RouteInitializedState: State {
        
        private unowned let route: MessagesContentRoute
        
        init(route: MessagesContentRoute) {
            self.route = route
        }
        
        final func showMessagesModule() {
            route.showMessagesModule()
        }
        
    }
    
    class UnauthenticatedState: RouteInitializedState {
        
        private unowned let router: ContentRouter
        
        init(route: MessagesContentRoute, router: ContentRouter) {
            self.router = router
            super.init(route: route)
        }
        
        override func process(_ content: MessagesContentRepresentation) {
            try? router.route(LoginContentRepresentation(completionHandler: { (loggedIn) in
                if loggedIn {
                    self.showMessagesModule()
                }
            }))
        }
        
    }
    
    class AuthenticatedState: RouteInitializedState {
        
        override func process(_ content: MessagesContentRepresentation) {
            showMessagesModule()
        }
        
    }
    
}
