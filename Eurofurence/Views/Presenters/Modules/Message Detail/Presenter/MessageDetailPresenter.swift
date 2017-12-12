//
//  MessageDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct MessageDetailPresenter {

    init(message: Message, scene: MessageDetailScene) {
        scene.setMessageDetailTitle(message.authorName)
        scene.setMessageSubject(message.subject)
        scene.setMessageContents(message.contents)
    }

}
