import ComponentBase
import EurofurenceModel
import RouterCore

public struct EventRoute {
    
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

extension EventRoute: Route {
    
    public typealias Parameter = EventRouteable
    
    public func route(_ content: EventRouteable) {
        let contentController = eventModuleFactory.makeEventDetailComponent(
            for: content.identifier,
            delegate: eventDetailDelegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
