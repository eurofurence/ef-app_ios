import EurofurenceModel
import RouterCore

public class LoadedContentRouter<R>: Router where R: Router {
    
    private let stateSensitiveRouter: WaitUntilInitialized<R>
    
    public init(stateService: SessionStateService, destinationRoutes: R) {
        stateSensitiveRouter = WaitUntilInitialized(router: destinationRoutes)
        stateService.add(observer: stateSensitiveRouter)
    }
    
    public func route<R>(_ content: R) throws where R: Routeable {
        try stateSensitiveRouter.route(content)
    }
    
    private class WaitUntilInitialized<R>: SessionStateObserver where R: Router {
        
        private let router: R
        private var currentSessionState: EurofurenceSessionState = .uninitialized
        private var pendingRoute: (() -> Void)?
        
        init(router: R) {
            self.router = router
        }
        
        func route<R>(_ content: R) throws where R: Routeable {
            if currentSessionState == .initialized {
                try router.route(content)
            } else {
                pendingRoute = { [weak self] in try? self?.router.route(content) }
            }
        }
        
        func sessionStateDidChange(_ newState: EurofurenceSessionState) {
            currentSessionState = newState
            pendingRoute?()
        }
        
    }
    
}
