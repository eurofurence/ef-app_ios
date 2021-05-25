import EurofurenceModel
import EventFeedbackComponent
import UIKit
import XCTComponentBase

public class StubEventFeedbackComponentFactory: EventFeedbackComponentFactory {
    
    public init() {
        
    }
    
    public let stubInterface = CapturingViewController()
    public private(set) var eventToLeaveFeedbackFor: EventIdentifier?
    private var delegate: EventFeedbackComponentDelegate?
    public func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackComponentDelegate
    ) -> UIViewController {
        eventToLeaveFeedbackFor = event
        self.delegate = delegate
        return stubInterface
    }
    
    public func simulateDismissFeedback() {
        delegate?.eventFeedbackCancelled()
    }
    
}
