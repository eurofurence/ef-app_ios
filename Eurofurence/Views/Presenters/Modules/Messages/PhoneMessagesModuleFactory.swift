//
//  PhoneMessagesModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct PhoneMessagesModuleFactory: MessagesModuleProviding {

    var sceneFactory: MessagesSceneFactory
    var authService: AuthService
    var privateMessagesService: PrivateMessagesService
    var dateFormatter: DateFormatterProtocol

    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeMessagesScene()
        _ = MessagesPresenter(scene: scene,
                              authService: authService,
                              privateMessagesService: privateMessagesService,
                              dateFormatter: dateFormatter,
                              delegate: delegate)

        return scene
    }

}
