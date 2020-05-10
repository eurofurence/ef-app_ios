import Eurofurence
import EurofurenceModel
import UIKit

class StubMapDetailComponentFactory: MapDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedModel: MapIdentifier?
    private(set) var delegate: MapDetailComponentDelegate?
    func makeMapDetailComponent(for map: MapIdentifier, delegate: MapDetailComponentDelegate) -> UIViewController {
        capturedModel = map
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMapDetailComponentFactory {

    func simulateDidSelectDealer(_ dealer: DealerIdentifier) {
        delegate?.mapDetailModuleDidSelectDealer(dealer)
    }

}
