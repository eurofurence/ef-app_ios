import ComponentBase
import EurofurenceModel
import RouterCore

public class MessagesRoute {
    
    private let messagesComponentFactory: MessagesComponentFactory
    private let contentWireframe: ContentWireframe
    private let delegate: MessagesComponentDelegate
    
    public init(
        messagesComponentFactory: MessagesComponentFactory,
        contentWireframe: ContentWireframe,
        delegate: MessagesComponentDelegate
    ) {
        self.messagesComponentFactory = messagesComponentFactory
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

// MARK: - Route

extension MessagesRoute: Route {
    
    public typealias Parameter = MessagesRouteable
    
    public func route(_ content: MessagesRouteable) {
        let contentController = messagesComponentFactory.makeMessagesModule(delegate)
        contentWireframe.presentPrimaryContentController(contentController)
    }
    
}
