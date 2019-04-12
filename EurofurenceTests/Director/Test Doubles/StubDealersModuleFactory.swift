@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubDealersModuleFactory: DealersModuleProviding {

    let stubInterface = FakeViewController()
    fileprivate var delegate: DealersModuleDelegate?
    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubDealersModuleFactory {

    func simulateDidSelectDealer(_ dealer: DealerIdentifier) {
        delegate?.dealersModuleDidSelectDealer(identifier: dealer)
    }

}
