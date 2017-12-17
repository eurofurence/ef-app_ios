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
    func setMessageSubject(_ subject: String)
    func setMessageContents(_ contents: String)

    func addMessageComponent()

}

protocol MessageDetailSceneDelegate {

    func messageDetailSceneDidLoad()
    func messageDetailSceneWillAppear()

}
