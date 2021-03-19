import EurofurenceModel
import UIKit

public struct FormSheetEventFeedbackComponentFactory: EventFeedbackComponentFactory {
    
    private let eventFeedbackComponentFactory: EventFeedbackComponentFactory
    
    public init(eventFeedbackComponentFactory: EventFeedbackComponentFactory) {
        self.eventFeedbackComponentFactory = eventFeedbackComponentFactory
    }
    
    public func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackComponentDelegate
    ) -> UIViewController {
        let contentController = eventFeedbackComponentFactory.makeEventFeedbackModule(for: event, delegate: delegate)
        let navigationController = UINavigationController(rootViewController: contentController)
        navigationController.modalPresentationStyle = .formSheet
        
        return navigationController
    }
    
}
