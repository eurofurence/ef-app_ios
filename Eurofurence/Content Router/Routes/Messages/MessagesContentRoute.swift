import EurofurenceModel

public struct MessagesContentRoute {
    
    private let messagesModuleProviding: MessagesModuleProviding
    private let contentWireframe: ContentWireframe
    
    public init(
        messagesModuleProviding: MessagesModuleProviding,
        contentWireframe: ContentWireframe
    ) {
        self.messagesModuleProviding = messagesModuleProviding
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension MessagesContentRoute: ContentRoute {
    
    public typealias Content = MessagesContentRepresentation
    
    public func route(_ content: MessagesContentRepresentation) {
        let contentController = messagesModuleProviding.makeMessagesModule(DummyDelegate())
        contentWireframe.presentMasterContentController(contentController)
    }
    
    private struct DummyDelegate: MessagesModuleDelegate {
        
        func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
            
        }
        
        func messagesModuleDidRequestPresentation(for message: MessageIdentifier) {
            
        }
        
        func messagesModuleDidRequestDismissal() {
            
        }
        
        func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void) {
            
        }
        
        func showLogoutFailedAlert() {
            
        }
        
    }
    
}
