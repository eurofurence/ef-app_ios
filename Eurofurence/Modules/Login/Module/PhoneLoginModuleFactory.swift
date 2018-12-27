//
//  PhoneLoginModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit.UIViewController

struct PhoneLoginModuleFactory: LoginModuleProviding {

    var sceneFactory: LoginSceneFactory
    var authenticationService: AuthenticationService
    var alertRouter: AlertRouter

    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeLoginScene()
        _ = LoginPresenter(delegate: delegate,
                           scene: scene,
                           authenticationService: authenticationService,
                           alertRouter: alertRouter)

        return scene
    }

}
