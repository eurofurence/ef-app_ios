import Eurofurence
import EurofurenceModel
import UIKit

class StubMapDetailModuleProviding: MapDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: MapIdentifier?
    private(set) var delegate: MapDetailModuleDelegate?
    func makeMapDetailModule(for map: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        capturedModel = map
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMapDetailModuleProviding {

    func simulateDidSelectDealer(_ dealer: DealerIdentifier) {
        delegate?.mapDetailModuleDidSelectDealer(dealer)
    }

}
