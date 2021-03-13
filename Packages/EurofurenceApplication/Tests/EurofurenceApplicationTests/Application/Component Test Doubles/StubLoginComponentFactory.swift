import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController

class StubLoginComponentFactory: LoginComponentFactory {

    let stubInterface = CapturingViewController()
    private(set) var delegate: LoginComponentDelegate?
    func makeLoginModule(_ delegate: LoginComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubLoginComponentFactory {

    func simulateLoginCancelled() {
        delegate?.loginModuleDidCancelLogin()
    }

    func simulateLoginSucceeded() {
        delegate?.loginModuleDidLoginSuccessfully()
    }

}
