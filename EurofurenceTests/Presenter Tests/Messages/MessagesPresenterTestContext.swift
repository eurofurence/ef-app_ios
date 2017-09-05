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
    var privateMessagesService = CapturingPrivateMessagesService()
    
    static func makeTestCaseForUnauthenticatedUser() -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedOut)
    }
    
    static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: ""),
                                                 privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()) -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedIn(user),
                                            privateMessagesService: privateMessagesService)
    }
    
    private init(authState: AuthState,
                 privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()) {
        self.privateMessagesService = privateMessagesService
        presenter = MessagesPresenter(scene: scene,
                                      authService: StubAuthService(authState: authState),
                                      privateMessagesService: privateMessagesService,
                                      resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                                      delegate: delegate)
    }
    
}
