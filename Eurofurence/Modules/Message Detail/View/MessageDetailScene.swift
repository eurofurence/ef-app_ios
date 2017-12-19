//
//  MessageDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol MessageDetailScene: class {

    var delegate: MessageDetailSceneDelegate? { get set }

    func setMessageDetailTitle(_ title: String)
    func addMessageComponent(with binder: MessageComponentBinder)

}

protocol MessageDetailSceneDelegate {

    func messageDetailSceneDidLoad()

}
