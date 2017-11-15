//
//  LoginSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol LoginSceneFactory {

    func makeLoginScene() -> UIViewController & LoginScene

}

protocol LoginScene {

    var delegate: LoginSceneDelegate? { get set }

    func disableLoginButton()
    func enableLoginButton()

}

protocol LoginSceneDelegate {

    func loginSceneDidUpdateRegistrationNumber(_ registrationNumberString: String)
    func loginSceneDidUpdateUsername(_ username: String)
    func loginSceneDidUpdatePassword(_ password: String)

}
