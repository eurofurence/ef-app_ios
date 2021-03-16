import UIKit

public struct CocoaTouchSuccessHaptic: SuccessHaptic {
    
    public init() {
        
    }
    
    public func play() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
}
