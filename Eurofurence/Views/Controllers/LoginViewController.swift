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

class LoginViewController: UITableViewController {

    // MARK: Properties

    weak var loginDelegate: LoginViewControllerDelegate?

    // MARK: IBActions

    @IBAction func cancelLogin(_ sender: Any) {
        loginDelegate?.loginViewControllerDidCancel(self)
    }

}
