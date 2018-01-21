//
//  LoginScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol LoginScene: class {

    var delegate: LoginSceneDelegate? { get set }

    func setLoginTitle(_ title: String)
    func disableLoginButton()
    func enableLoginButton()

}

protocol LoginSceneDelegate {

    func loginSceneWillAppear()
    func loginSceneDidTapCancelButton()
    func loginSceneDidTapLoginButton()
    func loginSceneDidUpdateRegistrationNumber(_ registrationNumberString: String)
    func loginSceneDidUpdateUsername(_ username: String)
    func loginSceneDidUpdatePassword(_ password: String)

}
