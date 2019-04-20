import Foundation

struct ShortDelayEventFeedbackSuccessWaitingRule: EventFeedbackSuccessWaitingRule {
    
    func evaluateRule(handler: @escaping () -> Void) {
        let now = DispatchTime.now()
        let threeSeconds = DispatchTime(uptimeNanoseconds: NSEC_PER_SEC * UInt64(3))
        let threeSecondsFromNow = DispatchTime(uptimeNanoseconds: now.rawValue + threeSeconds.rawValue)
        
        DispatchQueue.main.asyncAfter(deadline: threeSeconds, execute: handler)
    }
    
}
