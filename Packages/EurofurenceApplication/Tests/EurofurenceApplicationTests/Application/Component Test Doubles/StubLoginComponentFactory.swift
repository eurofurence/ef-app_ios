import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController
import XCTComponentBase

class StubLoginComponentFactory: LoginComponentFactory {
    
    init(stubInterface: CapturingViewController = CapturingViewController()) {
        self.stubInterface = stubInterface
    }

    let stubInterface: CapturingViewController
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
