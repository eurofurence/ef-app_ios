//
//  PhoneNewsModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct PhoneNewsModuleFactory: NewsModuleProviding {

    var newsSceneFactory: NewsSceneFactory
    var authenticationService: AuthenticationService
    var privateMessagesService: PrivateMessagesService

    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        let scene = newsSceneFactory.makeNewsScene()
        _ = NewsPresenter(delegate: delegate,
                          newsScene: scene,
                          authenticationService: authenticationService,
                          privateMessagesService: privateMessagesService)

        return scene
    }

}
