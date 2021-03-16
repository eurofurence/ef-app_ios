import EurofurenceComponentBase
import Foundation

public class CapturingSelectionChangedHaptic: SelectionChangedHaptic {
    
    public init() {
        
    }

    public private(set) var played = false
    public func play() {
        played = true
    }

}
