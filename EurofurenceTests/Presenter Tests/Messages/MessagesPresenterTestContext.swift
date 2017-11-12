//
//  MessagesPresenterTestContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingMessagesModuleDelegate: MessagesModuleDelegate {
    
    private(set) var wasToldToResolveUser = false
    private var userResolutionCompletionHandler: ((Bool) -> Void)?
    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        wasToldToResolveUser = true
        userResolutionCompletionHandler = completionHandler
    }
    
    private(set) var dismissed = false
    func messagesModuleDidRequestDismissal() {
        dismissed = true
    }
    
    func resolveUser() {
        userResolutionCompletionHandler?(true)
    }
    
    func failToResolveUser() {
        userResolutionCompletionHandler?(false)
    }
    
}

struct MessagesPresenterTestContext {
    
    let sceneFactory = StubMessagesSceneFactory()
    let delegate = CapturingMessagesModuleDelegate()
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
                                                 showMessageAction: showMessageAction,
                                                 dateFormatter: dateFormatter)
        _ = factory.makeMessagesModule(delegate)
    }
    
}
