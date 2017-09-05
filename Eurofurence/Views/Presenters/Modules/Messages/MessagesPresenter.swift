//
//  MessagesPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol MessagesPresenterDelegate {

    func dismissMessagesScene()

}

struct MessagesPresenter {

    private let scene: MessagesScene
    private let privateMessagesService: PrivateMessagesService
    private let resolveUserAuthenticationAction: ResolveUserAuthenticationAction
    private let delegate: MessagesPresenterDelegate

    init(scene: MessagesScene,
         authService: AuthService,
         privateMessagesService: PrivateMessagesService,
         resolveUserAuthenticationAction: ResolveUserAuthenticationAction,
         delegate: MessagesPresenterDelegate) {
        self.scene = scene
        self.privateMessagesService = privateMessagesService
        self.resolveUserAuthenticationAction = resolveUserAuthenticationAction
        self.delegate = delegate

        authService.determineAuthState(completionHandler: authStateResolved)
    }

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
        scene.showMessages(MessagesViewModel(messages: messages))
    }

}
