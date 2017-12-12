//
//  MessageDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class MessageDetailModuleBuilder {

    private struct DummyMessageDetailSceneFactory: MessageDetailSceneFactory {
        func makeMessageDetailScene() -> UIViewController & MessageDetailScene {
            return DummyScene()
        }

        private class DummyScene: UIViewController, MessageDetailScene {
            func setMessageDetailTitle(_ title: String) {

            }

            func setMessageSubject(_ subject: String) {

            }

            func setMessageContents(_ contents: String) {

            }
        }
    }

    private var messageDetailSceneFactory: MessageDetailSceneFactory

    init() {
        messageDetailSceneFactory = DummyMessageDetailSceneFactory()
    }

    func with(_ messageDetailSceneFactory: MessageDetailSceneFactory) -> MessageDetailModuleBuilder {
        self.messageDetailSceneFactory = messageDetailSceneFactory
        return self
    }

    func build() -> MessageDetailModuleProviding {
        return MessageDetailModuleFactory(messageDetailSceneFactory: messageDetailSceneFactory)
    }

}
