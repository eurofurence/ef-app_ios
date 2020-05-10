public struct DealerContentRoute {
    
    private let dealerModuleFactory: DealerDetailComponentFactory
    private let contentWireframe: ContentWireframe
    
    public init(dealerModuleFactory: DealerDetailComponentFactory, contentWireframe: ContentWireframe) {
        self.dealerModuleFactory = dealerModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension DealerContentRoute: ContentRoute {
    
    public typealias Content = DealerContentRepresentation
    
    public func route(_ content: DealerContentRepresentation) {
        let contentController = dealerModuleFactory.makeDealerDetailComponent(for: content.identifier)
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
