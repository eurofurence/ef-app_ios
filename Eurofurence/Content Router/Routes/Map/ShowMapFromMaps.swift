import EurofurenceModel

public struct ShowMapFromMaps: MapsModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func mapsModuleDidSelectMap(identifier: MapIdentifier) {
        try? router.route(MapContentRepresentation(identifier: identifier))
    }
    
}
