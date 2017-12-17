//
//  MessageDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct MessageDetailPresenter: MessageDetailSceneDelegate {

    private let message: Message
    private let scene: MessageDetailScene

    init(message: Message, scene: MessageDetailScene) {
        self.message = message
        self.scene = scene

        scene.delegate = self
    }

    func messageDetailSceneDidLoad() {
        scene.setMessageDetailTitle(message.authorName)
        scene.addMessageComponent()
    }

    func messageDetailSceneWillAppear() {
        scene.setMessageSubject(message.subject)
        scene.setMessageContents(message.contents)
    }

}
