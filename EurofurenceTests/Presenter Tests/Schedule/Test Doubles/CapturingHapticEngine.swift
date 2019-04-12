@testable import Eurofurence
import EurofurenceModel
import Foundation

class CapturingHapticEngine: HapticEngine {

    private(set) var didPlaySelectionHaptic = false
    func playSelectionHaptic() {
        didPlaySelectionHaptic = true
    }

}
