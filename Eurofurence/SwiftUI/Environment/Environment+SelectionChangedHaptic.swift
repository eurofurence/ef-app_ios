import SwiftUI

extension EnvironmentValues {
    
    /// A haptic to play to confirm a user-driven choice lead to a change in state.
    var selectionChangedHaptic: Haptics.SelectionChanged {
        get {
            self[SelectionChangedHapticEnvironmentKey.self]
        }
    }
    
    private struct SelectionChangedHapticEnvironmentKey: EnvironmentKey {
        
        typealias Value = Haptics.SelectionChanged
        
        static var defaultValue = Haptics.SelectionChanged()
        
    }
    
}
