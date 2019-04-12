@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingDealersModuleDelegate: DealersModuleDelegate {

    private(set) var capturedSelectedDealerIdentifier: DealerIdentifier?
    func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        capturedSelectedDealerIdentifier = identifier
    }

}
