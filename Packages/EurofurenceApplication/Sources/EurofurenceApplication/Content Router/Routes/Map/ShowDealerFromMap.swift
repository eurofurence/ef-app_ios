import EurofurenceModel

public struct ShowDealerFromMap: MapDetailComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
        try? router.route(EmbeddedDealerContentRepresentation(identifier: identifier))
    }
    
}
