@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class CapturingLoginScene: UIViewController, LoginScene {

    var delegate: LoginSceneDelegate?

    private(set) var capturedTitle: String?
    func setLoginTitle(_ title: String) {
        capturedTitle = title
    }

    var loginButtonWasDisabled = false
    func disableLoginButton() {
        loginButtonWasDisabled = true
    }

    private(set) var loginButtonWasEnabled = false
    func enableLoginButton() {
        loginButtonWasEnabled = true
    }

    func tapLoginButton() {
        delegate?.loginSceneDidTapLoginButton()
    }

}
