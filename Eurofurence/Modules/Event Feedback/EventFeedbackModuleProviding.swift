import EurofurenceModel
import UIKit.UIViewController

public protocol EventFeedbackModuleProviding {
    
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController
    
}
