import EurofurenceComponentBase
import Foundation

public struct MapContentRoute {
    
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

extension MapContentRoute: ContentRoute {
    
    public typealias Content = MapContentRepresentation
    
    public func route(_ content: MapContentRepresentation) {
        let contentController = mapModuleProviding.makeMapDetailComponent(
            for: content.identifier,
            delegate: delegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
