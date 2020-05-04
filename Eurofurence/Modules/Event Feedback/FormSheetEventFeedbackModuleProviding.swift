import EurofurenceModel
import UIKit

struct FormSheetEventFeedbackModuleProviding: EventFeedbackModuleProviding {
    
    var eventFeedbackModuleProviding: EventFeedbackModuleProviding
    
    func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackModuleDelegate
    ) -> UIViewController {
        let contentController = eventFeedbackModuleProviding.makeEventFeedbackModule(for: event, delegate: delegate)
        let navigationController = UINavigationController(rootViewController: contentController)
        navigationController.modalPresentationStyle = .formSheet
        
        return navigationController
    }
    
}
