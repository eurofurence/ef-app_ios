//
//  NewsPresenterTestContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct NewsPresenterTestContext {
    
    let authService: StubAuthenticationService
    let privateMessagesService: CapturingPrivateMessagesService
    let sceneFactory = StubNewsSceneFactory()
    let delegate = CapturingNewsModuleDelegate()
    
    var newsScene: CapturingNewsScene { return sceneFactory.stubbedScene }
    
    @discardableResult
    static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: ""),
                                                 privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authenticationService: StubAuthenticationService(authState: .loggedIn(user)),
                                      privateMessagesService: privateMessagesService)
    }
    
    @discardableResult
    static func makeTestCaseForAnonymousUser() -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authenticationService: StubAuthenticationService(authState: .loggedOut),
                                      privateMessagesService: CapturingPrivateMessagesService())
    }
    
    private init(authenticationService: StubAuthenticationService,
                 privateMessagesService: CapturingPrivateMessagesService) {
        self.authService = authenticationService
        self.privateMessagesService = privateMessagesService
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(privateMessagesService)
            .build()
            .makeNewsModule(delegate)
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
    }
    
}
