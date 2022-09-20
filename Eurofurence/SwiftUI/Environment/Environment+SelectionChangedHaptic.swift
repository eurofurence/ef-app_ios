import SwiftUI

extension EnvironmentValues {
    
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
