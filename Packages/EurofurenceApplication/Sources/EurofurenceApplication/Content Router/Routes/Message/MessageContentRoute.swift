import EurofurenceComponentBase
import Foundation

public struct MessageContentRoute {
    
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

// MARK: - ContentRoute

extension MessageContentRoute: ContentRoute {
    
    public typealias Content = MessageContentRepresentation
    
    public func route(_ content: MessageContentRepresentation) {
        let contentController = messageModuleFactory.makeMessageDetailComponent(for: content.identifier)
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
