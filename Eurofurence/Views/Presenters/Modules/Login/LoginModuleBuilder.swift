//
//  LoginModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class LoginModuleBuilder {

    private var sceneFactory: LoginSceneFactory
    private var loginService: LoginService
    private var presentationStrings: PresentationStrings
    private var alertRouter: AlertRouter

    init() {
        sceneFactory = LoginViewControllerV2Factory()
        loginService = EurofurenceLoginInteractor(app: EurofurenceApplication.shared)
        presentationStrings = UnlocalizedPresentationStrings()
        alertRouter = WindowAlertRouter.shared
    }

    func with(_ sceneFactory: LoginSceneFactory) -> LoginModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ loginService: LoginService) -> LoginModuleBuilder {
        self.loginService = loginService
        return self
    }

    func with(_ presentationStrings: PresentationStrings) -> LoginModuleBuilder {
        self.presentationStrings = presentationStrings
        return self
    }

    func with(_ alertRouter: AlertRouter) -> LoginModuleBuilder {
        self.alertRouter = alertRouter
        return self
    }

    func build() -> LoginModuleProviding {
        return PhoneLoginModuleFactory(sceneFactory: sceneFactory,
                                       loginService: loginService,
                                       presentationStrings: presentationStrings,
                                       alertRouter: alertRouter)
    }

}
