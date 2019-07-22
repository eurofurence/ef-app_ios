import UIKit.UIButton
import UIKit.UIViewController

class LoginViewController: UITableViewController, UITextFieldDelegate, LoginScene {

    // MARK: IBOutlets

    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var registrationNumberTextField: UITextField!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    // MARK: IBActions

    @IBAction private func loginButtonTapped(_ sender: Any) {
        delegate?.loginSceneDidTapLoginButton()
    }

    @IBAction private func cancelButtonTapped(_ sender: Any) {
        delegate?.loginSceneDidTapCancelButton()
    }

    @IBAction private func registrationNumberDidChange(_ sender: UITextField) {
        guard let registrationNumber = sender.text else { return }
        delegate?.loginSceneDidUpdateRegistrationNumber(registrationNumber)
    }

    @IBAction private func usernameDidChange(_ sender: UITextField) {
        guard let username = sender.text else { return }
        delegate?.loginSceneDidUpdateUsername(username)
    }

    @IBAction private func passwordDidChange(_ sender: UITextField) {
        guard let password = sender.text else { return }
        delegate?.loginSceneDidUpdatePassword(password)
    }
    
    @IBAction private func passwordPrimaryActionTriggered(_ sender: Any) {
        delegate?.loginSceneDidTapLoginButton()
    }
    
    // MARK: Overrides

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        delegate?.loginSceneWillAppear()
    }

    // MARK: LoginScene

    var delegate: LoginSceneDelegate?

    func setLoginTitle(_ title: String) {
        super.title = title
    }
    
    func overrideRegistrationNumber(_ registrationNumber: String) {
        registrationNumberTextField.text = registrationNumber
    }

    func disableLoginButton() {
        loginButton.isEnabled = false
    }

    func enableLoginButton() {
        loginButton.isEnabled = true
    }

}
