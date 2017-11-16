//
//  LoginPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class LoginPresenter: LoginSceneDelegate {

    private let delegate: LoginModuleDelegate
    private let scene: LoginScene
    private var registrationNumber: Int?
    private var username: String?
    private var password: String?

    init(delegate: LoginModuleDelegate, scene: LoginScene) {
        self.delegate = delegate
        self.scene = scene

        scene.delegate = self
        scene.disableLoginButton()
    }

    func loginSceneDidTapCancelButton() {
        delegate.loginModuleDidCancelLogin()
    }

    func loginSceneDidUpdateRegistrationNumber(_ registrationNumberString: String) {
        let scanner = Scanner(string: registrationNumberString)
        var container = 0
        if scanner.scanInt(&container) {
            registrationNumber = container

            if username != nil && !username!.isEmpty && password != nil && !password!.isEmpty {
                scene.enableLoginButton()
            }
        }
    }

    func loginSceneDidUpdateUsername(_ username: String) {
        self.username = username

        if !username.isEmpty && registrationNumber != nil && password != nil && !password!.isEmpty {
            scene.enableLoginButton()
        }
    }

    func loginSceneDidUpdatePassword(_ password: String) {
        self.password = password

        if !password.isEmpty && !username!.isEmpty && registrationNumber != nil {
            scene.enableLoginButton()
        }
    }

}
