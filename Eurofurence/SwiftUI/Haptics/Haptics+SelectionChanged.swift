import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Haptics {
    
    /// The selection changed haptic.
    ///
    /// Use the selection changed haptic to indicate changes to visual state based on user selection, e.g. button
    /// presses.
    struct SelectionChanged {
        
        func callAsFunction() {
#if os(iOS)
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
#endif
        }
        
    }
    
}
