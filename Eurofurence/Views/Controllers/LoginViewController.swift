//
//  LoginViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {

    func loginViewControllerDidCancel(_ loginController: LoginViewController)

}

class LoginViewController: UITableViewController,
                           UITextFieldDelegate {

    // MARK: Properties

    weak var loginDelegate: LoginViewControllerDelegate?
    private lazy var textFieldResponders: [UITextField] = {
        return [self.registrationNumberTextField,
                self.usernameTextField,
                self.passwordTextField]
    }()

    private var canAttemptLogin: Bool {
        guard let registrationNumber = registrationNumber,
              let username = username,
              let password = password else { return false }

        return !(registrationNumber.isEmpty || username.isEmpty || password.isEmpty)
    }

    private var registrationNumber: String? {
        return registrationNumberTextField.text
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard indexPath.row < textFieldResponders.count else { return }

        textFieldResponders[indexPath.row].becomeFirstResponder()
    }

}
