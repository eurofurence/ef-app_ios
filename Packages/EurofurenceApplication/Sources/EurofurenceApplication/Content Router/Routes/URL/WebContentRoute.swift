import ComponentBase
import Foundation

public struct WebContentRoute {
    
    private let webComponentFactory: WebComponentFactory
    private let modalWireframe: ModalWireframe
    
    public init(
        webComponentFactory: WebComponentFactory,
        modalWireframe: ModalWireframe
    ) {
        self.webComponentFactory = webComponentFactory
        self.modalWireframe = modalWireframe
    }
    
}

// MARK: - ContentRoute

extension WebContentRoute: ContentRoute {
    
    public typealias Content = WebContentRepresentation
    
    public func route(_ content: WebContentRepresentation) {
        let contentController = webComponentFactory.makeWebModule(for: content.url)
        modalWireframe.presentModalContentController(contentController)
    }
    
}
