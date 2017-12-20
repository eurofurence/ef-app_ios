//
//  MessagesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol MessagesSceneDelegate {

    func messagesSceneWillAppear()
    func messagesSceneDidSelectMessage(at indexPath: IndexPath)
    func messagesSceneDidPerformRefreshAction()

}

protocol MessagesSceneFactory {

    func makeMessagesScene() -> UIViewController & MessagesScene

}

protocol MessagesScene: class {

    var delegate: MessagesSceneDelegate? { get set }

    func setMessagesTitle(_ title: String)

    func showRefreshIndicator()
    func hideRefreshIndicator()

    func bindMessages(count: Int, with binder: MessageItemBinder)

    func showMessagesList()
    func hideMessagesList()

    func showNoMessagesPlaceholder()
    func hideNoMessagesPlaceholder()

}

protocol MessageItemBinder {

    func bind(_ scene: MessageItemScene, toMessageAt indexPath: IndexPath)

}

protocol MessageItemScene {

    func presentAuthor(_ author: String)
    func presentSubject(_ subject: String)
    func presentContents(_ contents: String)
    func presentReceivedDateTime(_ dateTime: String)
    func showUnreadIndicator()
    func hideUnreadIndicator()

}
