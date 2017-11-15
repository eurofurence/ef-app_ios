//
//  LoginPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct LoginPresenter: LoginSceneDelegate {

    private let delegate: LoginModuleDelegate

    init(delegate: LoginModuleDelegate, scene: LoginScene) {
        self.delegate = delegate

        scene.delegate = self
        scene.disableLoginButton()
        scene.enableLoginButton()
    }

    func loginSceneDidTapCancelButton() {
        delegate.loginModuleDidCancelLogin()
    }

    func loginSceneDidUpdateRegistrationNumber(_ registrationNumberString: String) {

    }

    func loginSceneDidUpdateUsername(_ username: String) {

    }

    func loginSceneDidUpdatePassword(_ password: String) {

    }

}
