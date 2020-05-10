@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubPreloadComponentFactoryImplFactory: PreloadComponentFactory {

    let stubInterface = UIViewController()
    private(set) var delegate: PreloadComponentDelegate?
    func makePreloadComponent(_ delegate: PreloadComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubPreloadComponentFactoryImplFactory {

    func simulatePreloadFinished() {
        delegate?.preloadModuleDidFinishPreloading()
    }

    func simulatePreloadCancelled() {
        delegate?.preloadModuleDidCancelPreloading()
    }

}
