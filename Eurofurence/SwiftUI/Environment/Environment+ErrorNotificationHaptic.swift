import SwiftUI

extension EnvironmentValues {
    
    /// A haptic to play when user-instigated operations fail.
    var errorNotificationHaptic: Haptics.ErrorNotification {
        self[ErrorNotificationHapticEnvironmentKey.self]
    }
    
    private struct ErrorNotificationHapticEnvironmentKey: EnvironmentKey {
        
        typealias Value = Haptics.ErrorNotification
        
        static var defaultValue = Haptics.ErrorNotification()
        
    }
    
}
