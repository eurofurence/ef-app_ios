import EurofurenceComponentBase
import EurofurenceModel

public struct ShowDealerFromDealers: DealersComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        try? router.route(DealerContentRepresentation(identifier: identifier))
    }
    
}
