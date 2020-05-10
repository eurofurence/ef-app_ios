import Eurofurence
import EurofurenceModel
import UIKit

class StubMapsComponentFactory: MapsComponentFactory {

    let stubInterface = FakeViewController()
    private(set) var delegate: MapsComponentDelegate?
    func makeMapsModule(_ delegate: MapsComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMapsComponentFactory {

    func simulateDidSelectMap(_ map: MapIdentifier) {
        delegate?.mapsComponentDidSelectMap(identifier: map)
    }

}
