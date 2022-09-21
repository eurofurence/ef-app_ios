import SwiftUI

extension EnvironmentValues {
    
    /// A haptic to play when user-instigated operations succeed.
    var successNotificationHaptic: Haptics.SuccessNotification {
        get {
            self[SuccessNotificationHapticEnvironmentKey.self]
        }
    }
    
    private struct SuccessNotificationHapticEnvironmentKey: EnvironmentKey {
        
        typealias Value = Haptics.SuccessNotification
        
        static var defaultValue = Haptics.SuccessNotification()
        
    }
    
}
