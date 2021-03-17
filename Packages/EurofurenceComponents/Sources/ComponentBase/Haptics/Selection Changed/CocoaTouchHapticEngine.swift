import UIKit

public struct CocoaTouchHapticEngine: SelectionChangedHaptic {
    
    public init() {
        
    }

    public func play() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

}
