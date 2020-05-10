import Foundation

protocol EventFeedbackSuccessWaitingRule {
    
    func evaluateRule(handler: @escaping () -> Void)
    
}
