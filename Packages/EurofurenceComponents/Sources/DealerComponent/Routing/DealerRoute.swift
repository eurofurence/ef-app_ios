import ComponentBase
import RouterCore

public struct DealerRoute {
    
    private let dealerModuleFactory: DealerDetailComponentFactory
    private let contentWireframe: ContentWireframe
    
    public init(dealerModuleFactory: DealerDetailComponentFactory, contentWireframe: ContentWireframe) {
        self.dealerModuleFactory = dealerModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - Route

extension DealerRoute: Route {
    
    public typealias Parameter = DealerRouteable
    
    public func route(_ content: DealerRouteable) {
        let contentController = dealerModuleFactory.makeDealerDetailComponent(for: content.identifier)
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
