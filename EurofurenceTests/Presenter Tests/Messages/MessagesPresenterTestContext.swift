//
//  MessagesPresenterTestContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingMessagesModuleDelegate: MessagesModuleDelegate {
    
    private(set) var dismissed = false
    func messagesModuleDidRequestDismissal() {
        dismissed = true
    }
    
}

struct MessagesPresenterTestContext {
    
    let sceneFactory = StubMessagesSceneFactory()
    let delegate = CapturingMessagesModuleDelegate()
    let resolveUserAuthenticationCommand = CapturingResolveUserAuthenticationAction()
    var privateMessagesService = CapturingPrivateMessagesService()
    let showMessageAction = CapturingShowMessageAction()
    let dateFormatter = CapturingDateFormatter()
    
    var scene: CapturingMessagesScene {
        return sceneFactory.scene
    }
    
    static func makeTestCaseForUnauthenticatedUser() -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedOut)
    }
    
    static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: ""),
                                                 privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()) -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedIn(user),
                                            privateMessagesService: privateMessagesService)
    }
    
    static func makeTestCaseForUserWithMessages(_ messages: [Message]) -> MessagesPresenterTestContext {
        let service = CapturingPrivateMessagesService(localMessages: messages)
        return makeTestCaseForAuthenticatedUser(privateMessagesService: service)
    }
    
    private init(authState: AuthState,
                 privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()) {
        self.privateMessagesService = privateMessagesService
        let factory = PhoneMessagesModuleFactory(sceneFactory: sceneFactory,
                                                 authService: StubAuthService(authState: authState),
                                                 privateMessagesService: privateMessagesService,
                                                 resolveUserAuthenticationAction: resolveUserAuthenticationCommand,
                                                 showMessageAction: showMessageAction,
                                                 dateFormatter: dateFormatter)
        _ = factory.makeMessagesModule(delegate)
    }
    
}
