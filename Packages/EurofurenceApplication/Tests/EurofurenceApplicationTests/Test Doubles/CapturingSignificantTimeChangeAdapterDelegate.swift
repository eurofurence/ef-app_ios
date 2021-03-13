import EurofurenceModel
import Foundation

class CapturingSignificantTimeChangeAdapterDelegate: SignificantTimeChangeAdapterDelegate {

    private(set) var toldSignificantTimeChangeOccurred = false
    func significantTimeChangeDidOccur() {
        toldSignificantTimeChangeOccurred = true
    }

}
