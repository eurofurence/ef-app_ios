import EurofurenceModel

public struct EventContentRoute {
    
    private let eventModuleFactory: EventDetailModuleProviding
    private let eventDetailDelegate: EventDetailModuleDelegate
    private let contentWireframe: ContentWireframe
    
    public init(
        eventModuleFactory: EventDetailModuleProviding,
        eventDetailDelegate: EventDetailModuleDelegate,
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
        let contentController = eventModuleFactory.makeEventDetailModule(
            for: content.identifier,
            delegate: eventDetailDelegate
        )
        
        contentWireframe.presentDetailContentController(contentController)
    }
    
}
