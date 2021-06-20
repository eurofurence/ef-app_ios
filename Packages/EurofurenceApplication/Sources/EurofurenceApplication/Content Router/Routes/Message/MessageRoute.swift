import ComponentBase
import RouterCore

public struct MessageRoute {
    
    private let messageModuleFactory: MessageDetailComponentFactory
    private let contentWireframe: ContentWireframe
    
    public init(
        messageModuleFactory: MessageDetailComponentFactory,
        contentWireframe: ContentWireframe
    ) {
        self.messageModuleFactory = messageModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - Route

extension MessageRoute: Route {
    
    public typealias Parameter = MessageRouteable
    
    public func route(_ content: MessageRouteable) {
        let contentController = messageModuleFactory.makeMessageDetailComponent(for: content.identifier)
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
