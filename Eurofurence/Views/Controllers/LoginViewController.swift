//
//  LoginViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {

    func loginViewControllerDidLoginSuccessfully(_ loginController: LoginViewController)
    func loginViewControllerDidCancel(_ loginController: LoginViewController)

}

class LoginViewController: UITableViewController, UITextFieldDelegate, LoginObserver {

    // MARK: Properties

    weak var loginDelegate: LoginViewControllerDelegate?
    private lazy var textFieldResponders: [UITextField] = {
        return [self.registrationNumberTextField,
                self.usernameTextField,
                self.passwordTextField]
    }()

    private var canAttemptLogin: Bool {
        guard registrationNumber != nil,
              let username = username,
              let password = password else { return false }

        return !(username.isEmpty || password.isEmpty)
    }

    private var registrationNumber: Int? {
        guard let text = registrationNumberTextField.text else { return nil }

        var regNo: Int = 0
        guard Scanner(string: text).scanInt(&regNo) else { return nil }

        return regNo
    }

    private var username: String? {
        return usernameTextField.text
    }

    private var password: String? {
        return passwordTextField.text
    }

    // MARK: IBOutlets

    @IBOutlet weak var registrationNumberTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var performLoginButton: UIButton!

    // MARK: IBActions

    @IBAction func performLogin(_ sender: Any) {
        guard let registrationNumber = registrationNumber,
              let username = username,
              let password = password else { return }

        let alert = UIAlertController(title: "Logging You In",
                                      message: "This may take a few moments",
                                      preferredStyle: .alert)

        present(alert, animated: true) {
            let loginArgs = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            EurofurenceApplication.shared.login(loginArgs)
        }
    }

    @IBAction func cancelLogin(_ sender: Any) {
        loginDelegate?.loginViewControllerDidCancel(self)
    }

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        performLoginButton.isEnabled = canAttemptLogin
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let index = textFieldResponders.index(of: textField) else { return true }

        textField.resignFirstResponder()
        let nextIndex = index + 1
        guard nextIndex < textFieldResponders.count else { return true }

        textFieldResponders[nextIndex].becomeFirstResponder()
        return true
    }

    // MARK: Overrides

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EurofurenceApplication.shared.add(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        EurofurenceApplication.shared.remove(self)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard indexPath.row < textFieldResponders.count else { return }

        textFieldResponders[indexPath.row].becomeFirstResponder()
    }

    // MARK: LoginObserver

    func userDidLogin() {
        dismiss(animated: true) {
            self.loginDelegate?.loginViewControllerDidLoginSuccessfully(self)
        }
    }

    func userDidFailToLogIn() {
        let alert = UIAlertController(title: "Unable to Login",
                                      message: "Please verify your login details and whether you have an active internet connection",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        dismiss(animated: true) {
            self.present(alert, animated: true)
        }
    }

}
