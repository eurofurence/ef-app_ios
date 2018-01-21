//
//  LoginViewControllerV2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIButton
import UIKit.UIViewController

class LoginViewControllerV2: UITableViewController, LoginScene {

    // MARK: IBOutlets

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var registrationNumberTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: IBActions

    @IBAction func loginButtonTapped(_ sender: Any) {
        delegate?.loginSceneDidTapLoginButton()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.loginSceneDidTapCancelButton()
    }

    @IBAction func registrationNumberDidChange(_ sender: UITextField) {
        guard let registrationNumber = sender.text else { return }
        delegate?.loginSceneDidUpdateRegistrationNumber(registrationNumber)
    }

    @IBAction func usernameDidChange(_ sender: UITextField) {
        guard let username = sender.text else { return }
        delegate?.loginSceneDidUpdateUsername(username)
    }

    @IBAction func passwordDidChange(_ sender: UITextField) {
        guard let password = sender.text else { return }
        delegate?.loginSceneDidUpdatePassword(password)
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

    func disableLoginButton() {
        loginButton.isEnabled = false
    }

    func enableLoginButton() {
        loginButton.isEnabled = true
    }

}
