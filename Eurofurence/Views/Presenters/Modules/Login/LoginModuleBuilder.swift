//
//  LoginModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class LoginModuleBuilder {

    private var sceneFactory: LoginSceneFactory
    private var authenticationService: AuthenticationService
    private var presentationStrings: PresentationStrings
    private var alertRouter: AlertRouter

    init() {
        sceneFactory = LoginViewControllerV2Factory()
        authenticationService = ApplicationAuthenticationService.shared
        presentationStrings = UnlocalizedPresentationStrings()
        alertRouter = WindowAlertRouter.shared
    }

    func with(_ sceneFactory: LoginSceneFactory) -> LoginModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ authenticationService: AuthenticationService) -> LoginModuleBuilder {
        self.authenticationService = authenticationService
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
                                       authenticationService: authenticationService,
                                       presentationStrings: presentationStrings,
                                       alertRouter: alertRouter)
    }

}
