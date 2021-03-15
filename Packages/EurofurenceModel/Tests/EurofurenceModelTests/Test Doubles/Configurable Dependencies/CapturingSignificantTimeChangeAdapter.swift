import EurofurenceModel
import Foundation

class CapturingSignificantTimeChangeAdapter: SignificantTimeChangeAdapter {

    private(set) var delegate: SignificantTimeChangeAdapterDelegate?
    func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate) {
        self.delegate = delegate
    }

}

extension CapturingSignificantTimeChangeAdapter {

    func simulateSignificantTimeChange() {
        delegate?.significantTimeChangeDidOccur()
    }

}
