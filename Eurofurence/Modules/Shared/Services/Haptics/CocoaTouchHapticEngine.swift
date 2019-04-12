import UIKit

struct CocoaTouchHapticEngine: HapticEngine {

    func playSelectionHaptic() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

}
