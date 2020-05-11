import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingDealersComponentDelegate: DealersComponentDelegate {

    private(set) var capturedSelectedDealerIdentifier: DealerIdentifier?
    func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        capturedSelectedDealerIdentifier = identifier
    }

}
