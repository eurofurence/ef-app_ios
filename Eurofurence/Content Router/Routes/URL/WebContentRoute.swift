import Foundation

public struct WebContentRoute {
    
    private let webModuleProviding: WebModuleProviding
    private let modalWireframe: ModalWireframe
    
    public init(
        webModuleProviding: WebModuleProviding,
        modalWireframe: ModalWireframe
    ) {
        self.webModuleProviding = webModuleProviding
        self.modalWireframe = modalWireframe
    }
    
}

// MARK: - ContentRoute

extension WebContentRoute: ContentRoute {
    
    public typealias Content = WebContentRepresentation
    
    public func route(_ content: WebContentRepresentation) {
        let contentController = webModuleProviding.makeWebModule(for: content.url)
        modalWireframe.presentModalContentController(contentController)
    }
    
}
