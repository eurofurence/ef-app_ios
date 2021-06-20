import ComponentBase
import RouterCore

public struct MapRoute {
    
    private let mapModuleProviding: MapDetailComponentFactory
    private let contentWireframe: ContentWireframe
    private let delegate: MapDetailComponentDelegate
    
    public init(
        mapModuleProviding: MapDetailComponentFactory,
        contentWireframe: ContentWireframe,
        delegate: MapDetailComponentDelegate
    ) {
        self.mapModuleProviding = mapModuleProviding
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

extension MapRoute: Route {
    
    public typealias Parameter = MapRouteable
    
    public func route(_ content: MapRouteable) {
        let contentController = mapModuleProviding.makeMapDetailComponent(
            for: content.identifier,
            delegate: delegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
