import EurofurenceApplication
import EurofurenceModel
import UIKit

class StubEventFeedbackComponentFactory: EventFeedbackComponentFactory {
    
    let stubInterface = CapturingViewController()
    private(set) var eventToLeaveFeedbackFor: EventIdentifier?
    private var delegate: EventFeedbackComponentDelegate?
    func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackComponentDelegate
    ) -> UIViewController {
        eventToLeaveFeedbackFor = event
        self.delegate = delegate
        return stubInterface
    }
    
    func simulateDismissFeedback() {
        delegate?.eventFeedbackCancelled()
    }
    
}
