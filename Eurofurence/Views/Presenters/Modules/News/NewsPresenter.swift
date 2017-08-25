//
//  NewsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct NewsPresenter: AuthStateObserver {

    private let newsScene: NewsScene
    private let welcomePromptStringFactory: WelcomePromptStringFactory

    init(authService: AuthService, newsScene: NewsScene, welcomePromptStringFactory: WelcomePromptStringFactory) {
        self.newsScene = newsScene
        self.welcomePromptStringFactory = welcomePromptStringFactory

        authService.determineAuthState { state in
            switch state {
            case .loggedIn(let user):
                newsScene.showMessagesNavigationAction()
                newsScene.hideLoginNavigationAction()
                newsScene.showWelcomePrompt(welcomePromptStringFactory.makeString(for: user))

            case .loggedOut:
                newsScene.showLoginNavigationAction()
                newsScene.hideMessagesNavigationAction()
                newsScene.showWelcomePrompt(welcomePromptStringFactory.makeStringForAnonymousUser())
            }
        }

        authService.add(observer: self)
    }

    func userDidLogin(_ user: User) {
        newsScene.showMessagesNavigationAction()
        newsScene.hideLoginNavigationAction()
        newsScene.showWelcomePrompt(welcomePromptStringFactory.makeString(for: user))
    }

}
