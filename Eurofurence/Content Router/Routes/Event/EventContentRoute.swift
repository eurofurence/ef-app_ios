import EurofurenceModel

public struct EventContentRoute {
    
    private let eventModuleFactory: EventDetailModuleProviding
    private let contentWireframe: ContentWireframe
    
    public init(eventModuleFactory: EventDetailModuleProviding, contentWireframe: ContentWireframe) {
        self.eventModuleFactory = eventModuleFactory
        self.contentWireframe = contentWireframe
    }
    
}

// MARK: - ContentRoute

extension EventContentRoute: ContentRoute {
    
    public typealias Content = EventContentRepresentation
    
    public func route(_ content: EventContentRepresentation) {
        let contentController = eventModuleFactory.makeEventDetailModule(
            for: content.identifier,
            delegate: DummyDelegate()
        )
        
        contentWireframe.presentDetailContentController(contentController)
    }
    
    private struct DummyDelegate: EventDetailModuleDelegate {
        
        func eventDetailModuleDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
            
        }
        
    }
    
}
