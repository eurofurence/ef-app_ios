import ComponentBase
import EurofurenceModel
import EventDetailComponent
import RouterCore

public struct EmbeddedEventRoute {
    
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

// MARK: - Route

extension EmbeddedEventRoute: Route {
    
    public typealias Parameter = EmbeddedEventRouteable
    
    public func route(_ content: EmbeddedEventRouteable) {
        let contentController = eventModuleFactory.makeEventDetailComponent(
            for: content.identifier,
            delegate: eventDetailDelegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
