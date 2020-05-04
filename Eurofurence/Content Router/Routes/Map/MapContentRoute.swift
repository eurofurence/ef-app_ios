import Foundation

public struct MapContentRoute {
    
    private let mapModuleProviding: MapDetailModuleProviding
    private let contentWireframe: ContentWireframe
    private let delegate: MapDetailModuleDelegate
    
    public init(
        mapModuleProviding: MapDetailModuleProviding,
        contentWireframe: ContentWireframe,
        delegate: MapDetailModuleDelegate
    ) {
        self.mapModuleProviding = mapModuleProviding
        self.contentWireframe = contentWireframe
        self.delegate = delegate
    }
    
}

extension MapContentRoute: ContentRoute {
    
    public typealias Content = MapContentRepresentation
    
    public func route(_ content: MapContentRepresentation) {
        let contentController = mapModuleProviding.makeMapDetailModule(
            for: content.identifier,
            delegate: delegate
        )
        
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
