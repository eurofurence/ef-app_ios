import Eurofurence
import EurofurenceModel
import Foundation

class CapturingSelectionChangedHaptic: SelectionChangedHaptic {

    private(set) var played = false
    func play() {
        played = true
    }

}
