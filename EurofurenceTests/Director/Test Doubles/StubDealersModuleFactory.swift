@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubDealersModuleFactory: DealersComponentFactory {

    let stubInterface = FakeViewController()
    fileprivate var delegate: DealersComponentDelegate?
    func makeDealersComponent(_ delegate: DealersComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubDealersModuleFactory {

    func simulateDidSelectDealer(_ dealer: DealerIdentifier) {
        delegate?.dealersModuleDidSelectDealer(identifier: dealer)
    }

}
