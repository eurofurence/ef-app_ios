//
//  LoginPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct LoginPresenter: LoginSceneDelegate {

    private let delegate: LoginModuleDelegate
    private let scene: LoginScene

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
        if scanner.scanInt(nil) {
            scene.enableLoginButton()
        }
    }

    func loginSceneDidUpdateUsername(_ username: String) {

    }

    func loginSceneDidUpdatePassword(_ password: String) {

    }

}
