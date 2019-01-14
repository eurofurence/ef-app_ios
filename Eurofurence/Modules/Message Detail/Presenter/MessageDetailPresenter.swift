//
//  MessageDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

struct MessageDetailPresenter: MessageDetailSceneDelegate {

    private let message: MessageCharacteristics
    private let scene: MessageDetailScene

    init(message: MessageCharacteristics, scene: MessageDetailScene) {
        self.message = message
        self.scene = scene

        scene.delegate = self
    }

    func messageDetailSceneDidLoad() {
        scene.setMessageDetailTitle(message.authorName)
        scene.addMessageComponent(with: MessageBinder(message: message))
    }

    private struct MessageBinder: MessageComponentBinder {

        var message: MessageCharacteristics

        func bind(_ component: MessageComponent) {
            component.setMessageSubject(message.subject)
            component.setMessageContents(message.contents)
        }

    }

}
