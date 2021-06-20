import ComponentBase
import DealerComponent
import RouterCore

public struct EmbeddedDealerRoute {
    
    private let dealerModuleFactory: DealerDetailComponentFactory
    private let contentWireframe: ContentWireframe
    
    public init(dealerModuleFactory: DealerDetailComponentFactory, contentWireframe: ContentWireframe) {
        self.dealerModuleFactory = dealerModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - Route

extension EmbeddedDealerRoute: Route {
    
    public typealias Parameter = EmbeddedDealerRouteable
    
    public func route(_ content: EmbeddedDealerRouteable) {
        let contentController = dealerModuleFactory.makeDealerDetailComponent(for: content.identifier)
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
