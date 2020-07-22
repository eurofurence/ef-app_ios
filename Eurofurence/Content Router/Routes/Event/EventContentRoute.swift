import EurofurenceModel

public struct EventContentRoute {
    
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

extension EventContentRoute: ContentRoute {
    
    public typealias Content = EventContentRepresentation
    
    public func route(_ content: EventContentRepresentation) {
        let contentController = eventModuleFactory.makeEventDetailComponent(
            for: content.identifier,
            delegate: eventDetailDelegate
        )
        
        contentWireframe.replaceDetailContentController(contentController)
    }
    
}
