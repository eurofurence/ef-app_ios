import EurofurenceModel
import RouterCore

public struct ShowDealerFromMap: MapDetailComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
        try? router.route(EmbeddedDealerRouteable(identifier: identifier))
    }
    
}
