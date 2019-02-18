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

    func makeMessageDetailModule(message: MessageEntity) -> UIViewController {
        let scene = messageDetailSceneFactory.makeMessageDetailScene()
        privateMessagesService.markMessageAsRead(message)
        _ = MessageDetailPresenter(message: message, scene: scene)

        return scene
    }

}
