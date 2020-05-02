import EurofurenceModel

public class MessagesContentRoute {
    
    private let messagesModuleProviding: MessagesModuleProviding
    private let contentWireframe: ContentWireframe
    private let delegate: MessagesModuleDelegate
    
    public init(
        messagesModuleProviding: MessagesModuleProviding,
        contentWireframe: ContentWireframe,
        delegate: MessagesModuleDelegate
    ) {
        self.messagesModuleProviding = messagesModuleProviding
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

// MARK: - ContentRoute

extension MessagesContentRoute: ContentRoute {
    
    public typealias Content = MessagesContentRepresentation
    
    public func route(_ content: MessagesContentRepresentation) {
        let contentController = messagesModuleProviding.makeMessagesModule(delegate)
        contentWireframe.presentMasterContentController(contentController)
    }
    
}
