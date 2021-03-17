import DealersComponent
import EurofurenceModel
import Foundation
import XCTEurofurenceModel

class CapturingDealersComponentDelegate: DealersComponentDelegate {

    private(set) var capturedSelectedDealerIdentifier: DealerIdentifier?
    func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        capturedSelectedDealerIdentifier = identifier
    }

}
