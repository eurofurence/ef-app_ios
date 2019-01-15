//
//  MessageDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit.UIViewController

class MessageDetailModuleBuilder {

    private var messageDetailSceneFactory: MessageDetailSceneFactory
    private var privateMessagesService: PrivateMessagesService

    init() {
        messageDetailSceneFactory = StoryboardMessageDetailSceneFactory()
        privateMessagesService = SharedModel.instance.services.privateMessages
    }

    func with(_ messageDetailSceneFactory: MessageDetailSceneFactory) -> MessageDetailModuleBuilder {
        self.messageDetailSceneFactory = messageDetailSceneFactory
        return self
    }

    @discardableResult
    func with(_ privateMessagesService: PrivateMessagesService) -> MessageDetailModuleBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }

    func build() -> MessageDetailModuleProviding {
        return MessageDetailModuleFactory(messageDetailSceneFactory: messageDetailSceneFactory,
                                          privateMessagesService: privateMessagesService)
    }

}
