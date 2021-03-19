import Foundation

public struct ShortDelayEventFeedbackSuccessWaitingRule: EventFeedbackSuccessWaitingRule {
    
    public init() {
        
    }
    
    public func evaluateRule(handler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: handler)
    }
    
}
