import EurofurenceModel
import UIKit.UIViewController

protocol EventFeedbackModuleProviding {
    
    func makeEventFeedbackModule(for event: Event) -> UIViewController
    
}
