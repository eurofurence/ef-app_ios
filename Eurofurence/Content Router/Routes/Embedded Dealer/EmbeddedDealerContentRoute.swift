public struct EmbeddedDealerContentRoute {
    
    private let dealerModuleFactory: DealerDetailComponentFactory
    private let contentWireframe: ContentWireframe
    
    public init(dealerModuleFactory: DealerDetailComponentFactory, contentWireframe: ContentWireframe) {
        self.dealerModuleFactory = dealerModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension EmbeddedDealerContentRoute: ContentRoute {
    
    public typealias Content = EmbeddedDealerContentRepresentation
    
    public func route(_ content: EmbeddedDealerContentRepresentation) {
        let contentController = dealerModuleFactory.makeDealerDetailComponent(for: content.identifier)
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
