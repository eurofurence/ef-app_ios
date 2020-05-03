import EurofurenceModel

public struct ShowDealerFromMap: MapDetailModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
        try? router.route(DealerContentRepresentation(identifier: identifier))
    }
    
}
