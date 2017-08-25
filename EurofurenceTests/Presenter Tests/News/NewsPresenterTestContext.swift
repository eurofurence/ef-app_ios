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
    
    @discardableResult
    static func makeTestCaseForAuthenticatedUser(_ user: User = User(registrationNumber: 42, username: ""),
                                                 welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authService: StubAuthService(authState: .loggedIn(user)),
                                        welcomePromptStringFactory: welcomePromptStringFactory)
    }
    
    @discardableResult
    static func makeTestCaseForAnonymousUser(welcomePromptStringFactory: WelcomePromptStringFactory = DummyWelcomePromptStringFactory()) -> NewsPresenterTestContext {
        return NewsPresenterTestContext(authService: StubAuthService(authState: .loggedOut),
                                        welcomePromptStringFactory: welcomePromptStringFactory)
    }
    
    private init(authService: StubAuthService, welcomePromptStringFactory: WelcomePromptStringFactory) {
        self.authService = authService
        presenter = NewsPresenter(authService: authService,
                                  newsScene: newsScene,
                                  welcomePromptStringFactory: welcomePromptStringFactory)
    }
    
}
