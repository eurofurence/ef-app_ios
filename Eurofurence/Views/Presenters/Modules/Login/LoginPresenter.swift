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
    private lazy var validator = LoginValidator(validationHandler: self.loginValidationStateDidChange)
    private lazy var validationActions: [LoginValidator.Result : () -> Void] = [
        .valid: self.scene.enableLoginButton,
        .invalid: self.scene.disableLoginButton
    ]

    private class LoginValidator {
        enum Result {
            case valid
            case invalid
        }

        var registrationNumber: String? {
            didSet { validate() }
        }

        var username: String? {
            didSet { validate() }
        }

        var password: String? {
            didSet { validate() }
        }

        private let  validationHandler: (Result) -> Void

        init(validationHandler: @escaping (Result) -> Void) {
            self.validationHandler = validationHandler
        }

        private var isValid: Bool {
            guard let registrationNumber = registrationNumber,
                  let username = username,
                  let password = password else { return false }

            return Scanner(string: registrationNumber).scanInt(nil) && !username.isEmpty && !password.isEmpty
        }

        private func validate() {
            validationHandler(isValid ? .valid : .invalid)
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
        validator.registrationNumber = registrationNumberString
    }

    func loginSceneDidUpdateUsername(_ username: String) {
        validator.username = username
    }

    func loginSceneDidUpdatePassword(_ password: String) {
        validator.password = password
    }

    private func loginValidationStateDidChange(_ state: LoginValidator.Result) {
        validationActions[state]?()
    }

}
