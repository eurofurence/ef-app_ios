import UIKit

public struct CocoaTouchFailureHaptic: FailureHaptic {
    
    public init() {
        
    }
    
    public func play() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
}
