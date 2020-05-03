import Eurofurence
import EurofurenceModel
import UIKit

class StubMapsModuleProviding: MapsModuleProviding {

    let stubInterface = FakeViewController()
    private(set) var delegate: MapsModuleDelegate?
    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMapsModuleProviding {

    func simulateDidSelectMap(_ map: MapIdentifier) {
        delegate?.mapsModuleDidSelectMap(identifier: map)
    }

}
