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

    init(scene: MessagesScene,
         authService: AuthService,
         privateMessagesService: PrivateMessagesService,
         resolveUserAuthenticationAction: ResolveUserAuthenticationAction,
         delegate: MessagesPresenterDelegate) {
        authService.determineAuthState { (state) in
            switch state {
            case .loggedIn(_):
                scene.showRefreshIndicator()
                privateMessagesService.refreshMessages()

            case .loggedOut:
                resolveUserAuthenticationAction.run { resolvedUser in
                    if !resolvedUser {
                        delegate.dismissMessagesScene()
                    }
                }
            }
        }
    }

}
