//
//  LoginPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class LoginPresenter: LoginSceneDelegate {

    private let delegate: LoginModuleDelegate
    private let scene: LoginScene
    private let authenticationService: AuthenticationService
    private let alertRouter: AlertRouter
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

        private let validationHandler: (Result) -> Void

        init(validationHandler: @escaping (Result) -> Void) {
            self.validationHandler = validationHandler
        }

        @discardableResult
        func makeLoginRequest() throws -> LoginArguments {
            return LoginArguments(registrationNumber: try retrieveRegistrationNumber(),
                                  username: try retrieveUsername(),
                                  password: try retrievePassword())
        }

        private struct ValidationError: Swift.Error {}

        private func retrieveUsername() throws -> String {
            guard let username = username, !username.isEmpty else { throw ValidationError() }
            return username
        }

        private func retrievePassword() throws -> String {
            guard let password = password, !password.isEmpty else { throw ValidationError() }
            return password
        }

        private func retrieveRegistrationNumber() throws -> Int {
            guard let registrationNumber = registrationNumber else { throw ValidationError() }

            var regNo = 0
            guard Scanner(string: registrationNumber).scanInt(&regNo) else { throw ValidationError() }

            return regNo
        }

        private var isValid: Bool {
            do {
                try makeLoginRequest()
                return true
            } catch {
                return false
            }
        }

        private func validate() {
            validationHandler(isValid ? .valid : .invalid)
        }
    }

    init(delegate: LoginModuleDelegate,
         scene: LoginScene,
         authenticationService: AuthenticationService,
         alertRouter: AlertRouter) {
        self.delegate = delegate
        self.scene = scene
        self.authenticationService = authenticationService
        self.alertRouter = alertRouter

        scene.delegate = self
        scene.setLoginTitle(.login)
    }

    func loginSceneWillAppear() {
        scene.disableLoginButton()
    }

    func loginSceneDidTapCancelButton() {
        delegate.loginModuleDidCancelLogin()
    }

    func loginSceneDidTapLoginButton() {
        guard let request = try? validator.makeLoginRequest() else { return }

        var alert = Alert(title: .loggingIn, message: .loggingInDetail)
        alert.onCompletedPresentation = { (dismissable) in
            self.authenticationService.login(request, completionHandler: { (result) in
                dismissable.dismiss {
                    switch result {
                    case .success:
                        self.delegate.loginModuleDidLoginSuccessfully()

                    case .failure:
                        let okayAction = AlertAction(title: .ok)
                        let loginErrorAlert = Alert(title: .loginError,
                                                    message: .loginErrorDetail,
                                                    actions: [okayAction])
                        self.alertRouter.show(loginErrorAlert)
                    }
                }
            })
        }

        alertRouter.show(alert)
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
