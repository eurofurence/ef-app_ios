import DealerComponent
import DealersComponent
import EurofurenceModel
import RouterCore

public struct ShowDealerFromDealers: DealersComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        try? router.route(DealerRouteable(identifier: identifier))
    }
    
}
