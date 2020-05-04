import Foundation

public struct MessageContentRoute {
    
    private let messageModuleFactory: MessageDetailModuleProviding
    private let contentWireframe: ContentWireframe
    
    public init(
        messageModuleFactory: MessageDetailModuleProviding,
        contentWireframe: ContentWireframe
    ) {
        self.messageModuleFactory = messageModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension MessageContentRoute: ContentRoute {
    
    public typealias Content = MessageContentRepresentation
    
    public func route(_ content: MessageContentRepresentation) {
        let contentController = messageModuleFactory.makeMessageDetailModule(for: content.identifier)
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
