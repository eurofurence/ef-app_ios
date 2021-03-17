import ComponentBase
import EurofurenceModel

public struct EmbeddedEventContentRoute {
    
    private let eventModuleFactory: EventDetailComponentFactory
    private let eventDetailDelegate: EventDetailComponentDelegate
    private let contentWireframe: ContentWireframe
    
    public init(
        eventModuleFactory: EventDetailComponentFactory,
        eventDetailDelegate: EventDetailComponentDelegate,
        contentWireframe: ContentWireframe
    ) {
        self.eventModuleFactory = eventModuleFactory
        self.eventDetailDelegate = eventDetailDelegate
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension EmbeddedEventContentRoute: ContentRoute {
    
    public typealias Content = EmbeddedEventContentRepresentation
    
    public func route(_ content: EmbeddedEventContentRepresentation) {
        let contentController = eventModuleFactory.makeEventDetailComponent(
            for: content.identifier,
            delegate: eventDetailDelegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
