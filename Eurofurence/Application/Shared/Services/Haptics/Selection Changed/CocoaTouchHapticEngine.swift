import UIKit

struct CocoaTouchHapticEngine: SelectionChangedHaptic {

    func play() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

}
