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

    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeLoginScene()
        _ = LoginPresenter(scene: scene)

        return scene
    }

}
