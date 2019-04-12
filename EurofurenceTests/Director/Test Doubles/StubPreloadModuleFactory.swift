@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubPreloadModuleFactory: PreloadModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: PreloadModuleDelegate?
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubPreloadModuleFactory {

    func simulatePreloadFinished() {
        delegate?.preloadModuleDidFinishPreloading()
    }

    func simulatePreloadCancelled() {
        delegate?.preloadModuleDidCancelPreloading()
    }

}
