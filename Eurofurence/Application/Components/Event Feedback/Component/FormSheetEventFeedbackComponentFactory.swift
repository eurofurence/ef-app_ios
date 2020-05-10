import EurofurenceModel
import UIKit

struct FormSheetEventFeedbackComponentFactory: EventFeedbackComponentFactory {
    
    var eventFeedbackComponentFactory: EventFeedbackComponentFactory
    
    func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackComponentDelegate
    ) -> UIViewController {
        let contentController = eventFeedbackComponentFactory.makeEventFeedbackModule(for: event, delegate: delegate)
        let navigationController = UINavigationController(rootViewController: contentController)
        navigationController.modalPresentationStyle = .formSheet
        
        return navigationController
    }
    
}
