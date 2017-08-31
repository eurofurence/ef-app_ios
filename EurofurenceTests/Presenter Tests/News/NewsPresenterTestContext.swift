//
//  NewsPresenterTestContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct NewsPresenterTestContext {
    
    var presenter: NewsPresenter
    var authService: StubAuthService
    let newsScene = CapturingNewsScene()
    let performLoginCommand = CapturingCommand()
    
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
        presenter = NewsPresenter(newsScene: newsScene,
                                  authService: authService,
                                  privateMessagesService: privateMessagesService,
                                  welcomePromptStringFactory: welcomePromptStringFactory,
                                  performLoginCommand: performLoginCommand)
    }
    
}
