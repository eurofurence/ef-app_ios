import ComponentBase
import EurofurenceModel

public class MessagesContentRoute {
    
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

// MARK: - ContentRoute

extension MessagesContentRoute: ContentRoute {
    
    public typealias Content = MessagesContentRepresentation
    
    public func route(_ content: MessagesContentRepresentation) {
        let contentController = messagesComponentFactory.makeMessagesModule(delegate)
        contentWireframe.presentPrimaryContentController(contentController)
    }
    
}
