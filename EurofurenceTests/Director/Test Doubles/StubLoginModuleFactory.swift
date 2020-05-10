@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubLoginModuleFactory: LoginComponentFactory {

    let stubInterface = CapturingViewController()
    private(set) var delegate: LoginComponentDelegate?
    func makeLoginModule(_ delegate: LoginComponentDelegate) -> UIViewController {
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
