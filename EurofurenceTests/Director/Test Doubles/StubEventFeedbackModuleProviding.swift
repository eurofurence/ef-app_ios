import Eurofurence
import EurofurenceModel
import UIKit

class StubEventFeedbackModuleProviding: EventFeedbackModuleProviding {
    
    let stubInterface = CapturingViewController()
    private(set) var eventToLeaveFeedbackFor: EventIdentifier?
    private var delegate: EventFeedbackModuleDelegate?
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        eventToLeaveFeedbackFor = event
        self.delegate = delegate
        return stubInterface
    }
    
    func simulateDismissFeedback() {
        delegate?.eventFeedbackCancelled()
    }
    
}
