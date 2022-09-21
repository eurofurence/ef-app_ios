import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Haptics {
    
    /// The success notification haptic.
    ///
    /// Use the success notification haptic to indicate an operation directly instigated by the user has concluded,
    /// e.g. submitting a form.
    struct SuccessNotification {
        
        func callAsFunction() {
#if os(iOS)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
#endif
        }
        
    }
    
}
