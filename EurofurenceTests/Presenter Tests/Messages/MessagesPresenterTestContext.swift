//
//  MessagesPresenterTestContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct MessagesPresenterTestContext {
    
    var presenter: MessagesPresenter
    let scene = CapturingMessagesScene()
    let delegate = CapturingMessagesPresenterDelegate()
    let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
    let privateMessagesService = CapturingPrivateMessagesService()
    
    static func makeTestCaseForUnauthenticatedUser() -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedOut)
    }
    
    static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: "")) -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedIn(user))
    }
    
    private init(authState: AuthState) {
        presenter = MessagesPresenter(scene: scene,
                                      authService: StubAuthService(authState: authState),
                                      privateMessagesService: privateMessagesService,
                                      resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                                      delegate: delegate)
    }
    
}
