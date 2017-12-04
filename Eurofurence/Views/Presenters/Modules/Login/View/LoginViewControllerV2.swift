//
//  LoginViewControllerV2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIButton
import UIKit.UIViewController

class LoginViewControllerV2: UIViewController, LoginScene {

    // MARK: IBOutlets

    @IBOutlet weak var loginButton: UIButton!

    // MARK: LoginScene

    var delegate: LoginSceneDelegate?

    func disableLoginButton() {

    }

    func enableLoginButton() {

    }

}
