//
//  NewsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct NewsPresenter: AuthenticationStateObserver, PrivateMessageUnreadCountObserver, NewsSceneDelegate {

    // MARK: Nested Types

    private class DetermineAuthStateOnce {

        private var ran = false
        private let authenticationService: AuthenticationService

        init(authenticationService: AuthenticationService) {
            self.authenticationService = authenticationService
        }

        func run(_ handler: @escaping (AuthState) -> Void) {
            guard !ran else { return }

            ran = true
            authenticationService.determineAuthState(completionHandler: handler)
        }

    }

    // MARK: Properties

    private let authenticationService: AuthenticationService
    private let delegate: NewsModuleDelegate
    private let newsScene: NewsScene
    private let welcomePromptStringFactory: WelcomePromptStringFactory
    private let privateMessagesService: PrivateMessagesService
    private let determineAuthStateOnce: DetermineAuthStateOnce

    // MARK: Initialization

    init(delegate: NewsModuleDelegate,
         newsScene: NewsScene,
         authenticationService: AuthenticationService,
         privateMessagesService: PrivateMessagesService,
         welcomePromptStringFactory: WelcomePromptStringFactory) {
        self.delegate = delegate
        self.newsScene = newsScene
        self.authenticationService = authenticationService
        self.welcomePromptStringFactory = welcomePromptStringFactory
        self.privateMessagesService = privateMessagesService

        determineAuthStateOnce = DetermineAuthStateOnce(authenticationService: authenticationService)

        newsScene.delegate = self
        authenticationService.add(observer: self)
    }

    // MARK: AuthStateObserver

    func userDidLogin(_ user: User) {
        newsScene.showMessagesNavigationAction()
        newsScene.hideLoginNavigationAction()
        newsScene.showWelcomePrompt(welcomePromptStringFactory.makeString(for: user))
        updateWelcomeDescriptionWithUnreadMessages(count: privateMessagesService.unreadMessageCount)
    }

    func userDidLogout() {
        newsScene.showLoginNavigationAction()
        newsScene.hideMessagesNavigationAction()
        newsScene.showLoginPrompt(welcomePromptStringFactory.makeStringForAnonymousUser())
        newsScene.showLoginDescription(welcomePromptStringFactory.makeDescriptionForAnonymousUser())
    }

    // MARK: PrivateMessageUnreadCountObserver

    func unreadPrivateMessagesCountDidChange(to unreadCount: Int) {
        updateWelcomeDescriptionWithUnreadMessages(count: unreadCount)
    }

    // MARK: NewsSceneDelegate

    func newsSceneWillAppear() {
        determineAuthStateOnce.run(authStateResolved)
        privateMessagesService.add(self)
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

    private func updateWelcomeDescriptionWithUnreadMessages(count: Int) {
        let unreadMessagesDescription = welcomePromptStringFactory.makeDescriptionForUnreadMessages(count)
        newsScene.showWelcomeDescription(unreadMessagesDescription)
    }

}
