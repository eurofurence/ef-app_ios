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
                                                 welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory(),
                                                 privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authenticationService: StubAuthenticationService(authState: .loggedIn(user)),
                                        welcomePromptStringFactory: welcomePromptStringFactory,
                                        privateMessagesService: privateMessagesService)
    }
    
    @discardableResult
    static func makeTestCaseForAnonymousUser(welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authenticationService: StubAuthenticationService(authState: .loggedOut),
                                        welcomePromptStringFactory: welcomePromptStringFactory,
                                        privateMessagesService: CapturingPrivateMessagesService())
    }
    
    private init(authenticationService: StubAuthenticationService,
                 welcomePromptStringFactory: WelcomePromptStringFactory,
                 privateMessagesService: CapturingPrivateMessagesService) {
        self.authService = authenticationService
        self.privateMessagesService = privateMessagesService
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(authenticationService)
            .with(privateMessagesService)
            .with(welcomePromptStringFactory)
            .build()
            .makeNewsModule(delegate)
        sceneFactory.stubbedScene.delegate?.newsSceneWillAppear()
    }
    
}
