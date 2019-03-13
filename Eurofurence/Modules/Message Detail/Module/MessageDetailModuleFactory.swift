//
//  MessageDetailModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit.UIViewController

struct MessageDetailModuleFactory: MessageDetailModuleProviding {

    var messageDetailSceneFactory: MessageDetailSceneFactory
    var privateMessagesService: PrivateMessagesService

    func makeMessageDetailModule(message: Message) -> UIViewController {
        let scene = messageDetailSceneFactory.makeMessageDetailScene()
        _ = MessageDetailPresenter(message: message, scene: scene)

        return scene
    }

}
