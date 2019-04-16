import UIKit

struct CocoaTouchFailureHaptic: FailureHaptic {
    
    func play() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
}
