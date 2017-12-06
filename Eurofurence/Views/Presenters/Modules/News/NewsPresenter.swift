//
//  NewsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct NewsPresenter: AuthStateObserver, NewsSceneDelegate {

    // MARK: Nested Types

    private class DetermineAuthStateOnce {

        private var ran = false
        private let authService: AuthService

        init(authService: AuthService) {
            self.authService = authService
        }

        func run(_ handler: @escaping (AuthState) -> Void) {
            guard !ran else { return }

            ran = true
            authService.determineAuthState(completionHandler: handler)
        }

    }

    // MARK: Properties

    private let authService: AuthService
    private let delegate: NewsModuleDelegate
    private let newsScene: NewsScene
    private let welcomePromptStringFactory: WelcomePromptStringFactory
    private let privateMessagesService: PrivateMessagesService
    private let determineAuthStateOnce: DetermineAuthStateOnce

    // MARK: Initialization

    init(delegate: NewsModuleDelegate,
         newsScene: NewsScene,
         authService: AuthService,
         privateMessagesService: PrivateMessagesService,
         welcomePromptStringFactory: WelcomePromptStringFactory) {
        self.delegate = delegate
        self.newsScene = newsScene
        self.authService = authService
        self.welcomePromptStringFactory = welcomePromptStringFactory
        self.privateMessagesService = privateMessagesService

        determineAuthStateOnce = DetermineAuthStateOnce(authService: authService)

        newsScene.delegate = self
        authService.add(observer: self)
    }

    // MARK: AuthStateObserver

    func userDidLogin(_ user: User) {
        newsScene.showMessagesNavigationAction()
        newsScene.hideLoginNavigationAction()
        newsScene.showWelcomePrompt(welcomePromptStringFactory.makeString(for: user))

        let unreadMessageCount = privateMessagesService.unreadMessageCount
        let unreadMessagesDescription = welcomePromptStringFactory.makeDescriptionForUnreadMessages(unreadMessageCount)
        newsScene.showWelcomeDescription(unreadMessagesDescription)
    }

    func userDidLogout() {
        newsScene.showLoginNavigationAction()
        newsScene.hideMessagesNavigationAction()
        newsScene.showLoginPrompt(welcomePromptStringFactory.makeStringForAnonymousUser())
        newsScene.showLoginDescription(welcomePromptStringFactory.makeDescriptionForAnonymousUser())
    }

    // MARK: NewsSceneDelegate

    func newsSceneWillAppear() {
        determineAuthStateOnce.run(authStateResolved)
    }

    func newsSceneDidTapLoginAction(_ scene: NewsScene) {
        delegate.newsModuleDidRequestLogin()
    }

    func newsSceneDidTapShowMessagesAction(_ scene: NewsScene) {
        delegate.newsModuleDidRequestShowingPrivateMessages()
    }

    // MARK: Private

    private func authStateResolved(_ state: AuthState) {
        switch state {
        case .loggedIn(let user):
            userDidLogin(user)

        case .loggedOut:
            userDidLogout()
        }
    }

}
