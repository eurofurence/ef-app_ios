import Foundation

public protocol EventFeedbackSuccessWaitingRule {
    
    func evaluateRule(handler: @escaping () -> Void)
    
}
