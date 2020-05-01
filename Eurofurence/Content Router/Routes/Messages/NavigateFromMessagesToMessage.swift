import EurofurenceModel

public struct NavigateFromMessagesToMessage: MessagesModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    public func messagesModuleDidRequestPresentation(for message: MessageIdentifier) {
        try? router.route(MessageContentRepresentation(identifier: message))
    }
    
    public func messagesModuleDidRequestDismissal() {
        
    }
    
    public func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void) {
        
    }
    
    public func showLogoutFailedAlert() {
        
    }
    
}
