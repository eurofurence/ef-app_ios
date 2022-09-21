import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Haptics {
    
    /// The error notification haptic.
    ///
    /// Use the error notification haptic to indicate an operation directly instigated by the user has failed to
    /// complete, e.g. form submission.
    struct ErrorNotification {
        
        func callAsFunction() {
#if os(iOS)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
#endif
        }
        
    }
    
}
