import ComponentBase
import RouterCore
import UIKit.UIViewController

public struct EventFeedbackRoute {
    
    private let eventFeedbackFactory: EventFeedbackComponentFactory
    private let modalWireframe: ModalWireframe
    
    public init(eventFeedbackFactory: EventFeedbackComponentFactory, modalWireframe: ModalWireframe) {
        self.eventFeedbackFactory = eventFeedbackFactory
        self.modalWireframe = modalWireframe
    }
    
}

// MARK: - Route

extension EventFeedbackRoute: Route {
    
    public typealias Parameter = EventFeedbackRouteable
    
    public func route(_ content: EventFeedbackRouteable) {
        let delegate = DismissControllerWhenCancellingFeedback()
        let contentController = eventFeedbackFactory.makeEventFeedbackModule(
            for: content.identifier,
            delegate: delegate
        )
        
        delegate.viewController = contentController
        
        modalWireframe.presentModalContentController(contentController)
    }
    
    private class DismissControllerWhenCancellingFeedback: EventFeedbackComponentDelegate {
        
        weak var viewController: UIViewController?
        
        func eventFeedbackCancelled() {
            viewController?.dismiss(animated: true)
        }
        
    }
    
}
