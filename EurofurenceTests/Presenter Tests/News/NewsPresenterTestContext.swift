//
//  NewsPresenterTestContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct NewsPresenterTestContext {
    
    var authService: StubAuthService
    let newsScene = CapturingNewsScene()
    let delegate = CapturingNewsModuleDelegate()
    
    @discardableResult
    static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: ""),
                                                 welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory(),
                                                 privateMessagesService: PrivateMessagesService = DummyPrivateMessagesService()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authService: StubAuthService(authState: .loggedIn(user)),
                                        welcomePromptStringFactory: welcomePromptStringFactory,
                                        privateMessagesService: privateMessagesService)
    }
    
    @discardableResult
    static func makeTestCaseForAnonymousUser(welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authService: StubAuthService(authState: .loggedOut),
                                        welcomePromptStringFactory: welcomePromptStringFactory,
                                        privateMessagesService: DummyPrivateMessagesService())
    }
    
    private init(authService: StubAuthService,
                 welcomePromptStringFactory: WelcomePromptStringFactory,
                 privateMessagesService: PrivateMessagesService) {
        self.authService = authService
        let factory = PhoneNewsModuleFactory(delegate: delegate,
                                             newsScene: newsScene,
                                             authService: authService,
                                             privateMessagesService: privateMessagesService,
                                             welcomePromptStringFactory: welcomePromptStringFactory)
        _ = factory.makeNewsModule()
    }
    
}
