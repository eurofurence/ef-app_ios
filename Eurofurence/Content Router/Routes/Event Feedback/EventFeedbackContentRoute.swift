public struct EventFeedbackContentRoute {
    
    private let eventFeedbackFactory: EventFeedbackModuleProviding
    private let modalWireframe: ModalWireframe
    
    public init(eventFeedbackFactory: EventFeedbackModuleProviding, modalWireframe: ModalWireframe) {
        self.eventFeedbackFactory = eventFeedbackFactory
        self.modalWireframe = modalWireframe
    }
    
}

// MARK: - ContentRoute

extension EventFeedbackContentRoute: ContentRoute {
    
    public typealias Content = EventFeedbackContentRepresentation
    
    public func route(_ content: EventFeedbackContentRepresentation) {
        let contentController = eventFeedbackFactory.makeEventFeedbackModule(
            for: content.identifier,
            delegate: DummyDelegate()
        )
        
        modalWireframe.presentModalContentController(contentController)
    }
    
    private struct DummyDelegate: EventFeedbackModuleDelegate {
        
        func eventFeedbackCancelled() {
            
        }
        
    }
    
}
