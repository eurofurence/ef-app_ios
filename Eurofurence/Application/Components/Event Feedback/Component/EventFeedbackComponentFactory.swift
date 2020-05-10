import EurofurenceModel
import UIKit.UIViewController

public protocol EventFeedbackComponentFactory {
    
    func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackComponentDelegate
    ) -> UIViewController
    
}
