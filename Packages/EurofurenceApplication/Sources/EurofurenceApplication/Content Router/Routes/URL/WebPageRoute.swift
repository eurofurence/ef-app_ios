import ComponentBase
import RouterCore

public struct WebPageRoute {
    
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

// MARK: - Route

extension WebPageRoute: Route {
    
    public typealias Parameter = WebRouteable
    
    public func route(_ content: WebRouteable) {
        let contentController = webComponentFactory.makeWebModule(for: content.url)
        modalWireframe.presentModalContentController(contentController)
    }
    
}
