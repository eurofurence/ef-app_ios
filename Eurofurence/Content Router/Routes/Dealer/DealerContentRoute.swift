public struct DealerContentRoute {
    
    private let dealerModuleFactory: DealerDetailModuleProviding
    private let contentWireframe: ContentWireframe
    
    public init(dealerModuleFactory: DealerDetailModuleProviding, contentWireframe: ContentWireframe) {
        self.dealerModuleFactory = dealerModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension DealerContentRoute: ContentRoute {
    
    public typealias Content = DealerContentRepresentation
    
    public func route(_ content: DealerContentRepresentation) {
        let contentController = dealerModuleFactory.makeDealerDetailModule(for: content.identifier)
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
