//
//  MessagesPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation.NSIndexPath

class MessagesPresenter: MessagesSceneDelegate {

    // MARK: Properties

    private let scene: MessagesScene
    private let privateMessagesService: PrivateMessagesService
    private let showMessageAction: ShowMessageAction
    private let dateFormatter: DateFormatterProtocol
    private let delegate: MessagesModuleDelegate
    private var presentedMessages = [Message]()

    // MARK: Initialization

    init(scene: MessagesScene,
         authService: AuthService,
         privateMessagesService: PrivateMessagesService,
         showMessageAction: ShowMessageAction,
         dateFormatter: DateFormatterProtocol,
         delegate: MessagesModuleDelegate) {
        self.scene = scene
        self.privateMessagesService = privateMessagesService
        self.showMessageAction = showMessageAction
        self.dateFormatter = dateFormatter
        self.delegate = delegate

        scene.delegate = self
        authService.determineAuthState(completionHandler: authStateResolved)
    }

    // MARK: MessagesSceneDelegate

    func messagesSceneDidSelectMessage(at indexPath: IndexPath) {
        let message = presentedMessages[indexPath[1]]
        showMessageAction.show(message: message)
    }

    // MARK: Private

    private func authStateResolved(_ state: AuthState) {
        switch state {
        case .loggedIn(_):
            presentMessages(privateMessagesService.localMessages)
            reloadPrivateMessages()

        case .loggedOut:
            delegate.messagesModuleDidRequestResolutionForUser(completionHandler: userResolved)
        }
    }

    private func userResolved(_ resolved: Bool) {
        if resolved {
            reloadPrivateMessages()
        } else {
            delegate.messagesModuleDidRequestDismissal()
        }
    }

    private func reloadPrivateMessages() {
        scene.showRefreshIndicator()
        privateMessagesService.refreshMessages(completionHandler: privateMessagesDidFinishRefreshing)
    }

    private func privateMessagesDidFinishRefreshing(_ result: PrivateMessagesRefreshResult) {
        scene.hideRefreshIndicator()

        if case .success(let messages) = result {
            presentMessages(messages)
        }
    }

    private func presentMessages(_ messages: [Message]) {
        presentedMessages = messages
        scene.bindMessages(with: MessageBinder(messages: messages, dateFormatter: dateFormatter))

        if messages.isEmpty {
            scene.hideMessagesList()
            scene.showNoMessagesPlaceholder()
        } else {
            scene.showMessagesList()
            scene.hideNoMessagesPlaceholder()
        }
    }

    private struct MessageBinder: MessageItemBinder {

        var messages: [Message]
        var dateFormatter: DateFormatterProtocol

        var numberOfMessages: Int {
            return messages.count
        }

        func bind(_ scene: MessageItemScene, toMessageAt indexPath: IndexPath) {
            let message = messages[indexPath[1]]

            scene.presentAuthor(message.authorName)
            scene.presentSubject(message.subject)
            scene.presentContents(message.contents)

            if message.isRead {
                scene.hideUnreadIndicator()
            } else {
                scene.showUnreadIndicator()
            }

            let formattedDateTime = dateFormatter.string(from: message.receivedDateTime)
            scene.presentReceivedDateTime(formattedDateTime)
        }

    }

}
