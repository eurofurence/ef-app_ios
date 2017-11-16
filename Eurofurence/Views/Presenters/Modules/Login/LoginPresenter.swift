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
    private let inputContainer = InputContainer()

    private class InputContainer {
        var registrationNumber: Int?
        var username: String?
        var password: String?

        var isValid: Bool {
            guard let username = username, let password = password else { return false }
            return registrationNumber != nil && !username.isEmpty && !password.isEmpty
        }

        func updateRegistrationNumber(with string: String) {
            var container = 0
            if Scanner(string: string).scanInt(&container) {
                registrationNumber = container
            }
        }
    }

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
        inputContainer.updateRegistrationNumber(with: registrationNumberString)
        if inputContainer.isValid {
            scene.enableLoginButton()
        }
    }

    func loginSceneDidUpdateUsername(_ username: String) {
        inputContainer.username = username
        if inputContainer.isValid {
            scene.enableLoginButton()
        }
    }

    func loginSceneDidUpdatePassword(_ password: String) {
        inputContainer.password = password
        if inputContainer.isValid {
            scene.enableLoginButton()
        }
    }

}
