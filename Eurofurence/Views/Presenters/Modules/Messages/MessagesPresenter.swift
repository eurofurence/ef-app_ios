//
//  MessagesPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol MessagesPresenterDelegate {

    func dismissMessagesScene()

}

class MessagesPresenter: MessagesSceneDelegate {

    // MARK: Properties

    private let scene: MessagesScene
    private let privateMessagesService: PrivateMessagesService
    private let resolveUserAuthenticationAction: ResolveUserAuthenticationAction
    private let showMessageAction: ShowMessageAction
    private let delegate: MessagesPresenterDelegate
    private var presentedMessages = [Message]()

    // MARK: Initialization

    init(scene: MessagesScene,
         authService: AuthService,
         privateMessagesService: PrivateMessagesService,
         resolveUserAuthenticationAction: ResolveUserAuthenticationAction,
         showMessageAction: ShowMessageAction,
         delegate: MessagesPresenterDelegate) {
        self.scene = scene
        self.privateMessagesService = privateMessagesService
        self.resolveUserAuthenticationAction = resolveUserAuthenticationAction
        self.showMessageAction = showMessageAction
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
            resolveUserAuthenticationAction.run(completionHandler: userResolved)
        }
    }

    private func userResolved(_ resolved: Bool) {
        if resolved {
            reloadPrivateMessages()
        } else {
            delegate.dismissMessagesScene()
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
        scene.showMessages(MessagesViewModel(childViewModels: messages.map(makeViewModel)))
    }

    private func makeViewModel(for message: Message) -> MessageViewModel {
        return MessageViewModel(author: message.authorName,
                                formattedReceivedDate: "",
                                subject: message.subject,
                                isRead: message.isRead)
    }

}
