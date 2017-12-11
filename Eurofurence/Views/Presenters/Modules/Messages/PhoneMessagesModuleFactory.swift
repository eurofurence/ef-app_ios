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
    var authenticationService: AuthenticationService
    var privateMessagesService: PrivateMessagesService
    var dateFormatter: DateFormatterProtocol
    var presentationStrings: PresentationStrings

    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeMessagesScene()
        _ = MessagesPresenter(scene: scene,
                              authenticationService: authenticationService,
                              privateMessagesService: privateMessagesService,
                              dateFormatter: dateFormatter,
                              presentationStrings: presentationStrings,
                              delegate: delegate)

        return scene
    }

}
