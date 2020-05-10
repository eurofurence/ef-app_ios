import UIKit

struct CocoaTouchSuccessHaptic: SuccessHaptic {
    
    func play() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
}
