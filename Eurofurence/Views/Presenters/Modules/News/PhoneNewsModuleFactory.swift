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
    var authService: AuthService
    var privateMessagesService: PrivateMessagesService
    var welcomePromptStringFactory: WelcomePromptStringFactory

    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        let scene = newsSceneFactory.makeNewsScene()
        _ = NewsPresenter(delegate: delegate,
                          newsScene: scene,
                          authService: authService,
                          privateMessagesService: privateMessagesService,
                          welcomePromptStringFactory: welcomePromptStringFactory)

        return scene
    }

}
