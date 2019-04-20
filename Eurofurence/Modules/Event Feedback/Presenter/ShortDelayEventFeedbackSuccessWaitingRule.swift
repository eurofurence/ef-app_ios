import Foundation

struct ShortDelayEventFeedbackSuccessWaitingRule: EventFeedbackSuccessWaitingRule {
    
    func evaluateRule(handler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: handler)
    }
    
}
