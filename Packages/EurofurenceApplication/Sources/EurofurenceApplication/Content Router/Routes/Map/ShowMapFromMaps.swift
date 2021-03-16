import EurofurenceComponentBase
import EurofurenceModel

public struct ShowMapFromMaps: MapsComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func mapsComponentDidSelectMap(identifier: MapIdentifier) {
        try? router.route(MapContentRepresentation(identifier: identifier))
    }
    
}
