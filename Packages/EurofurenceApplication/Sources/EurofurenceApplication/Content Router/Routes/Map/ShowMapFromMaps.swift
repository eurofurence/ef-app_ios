import EurofurenceModel
import RouterCore

public struct ShowMapFromMaps: MapsComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func mapsComponentDidSelectMap(identifier: MapIdentifier) {
        try? router.route(MapRouteable(identifier: identifier))
    }
    
}
