@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubLoginModuleFactory: LoginModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: LoginModuleDelegate?
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubLoginModuleFactory {

    func simulateLoginCancelled() {
        delegate?.loginModuleDidCancelLogin()
    }

    func simulateLoginSucceeded() {
        delegate?.loginModuleDidLoginSuccessfully()
    }

}
