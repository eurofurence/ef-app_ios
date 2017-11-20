//
//  PhoneLoginModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct PhoneLoginModuleFactory: LoginModuleFactory {

    var sceneFactory: LoginSceneFactory
    var loginService: LoginService

    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeLoginScene()
        _ = LoginPresenter(delegate: delegate, scene: scene, loginService: loginService)

        return scene
    }

}
