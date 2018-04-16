//
//  NewsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct NewsPresenter: AuthenticationStateObserver, PrivateMessagesServiceObserver, NewsSceneDelegate {

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

    private struct Binder: NewsComponentsBinder {

        var viewModel: NewsViewModel

        func bindTitleForSection(at index: Int, scene: NewsComponentHeaderScene) {
            scene.setComponentTitle(viewModel.titleForComponent(at: index))
        }

        func bindComponent(at indexPath: IndexPath, using componentFactory: NewsComponentFactory) {
            let visitor = Visitor(componentFactory: componentFactory)
            viewModel.describeComponent(at: indexPath, to: visitor)
        }

    }

    private struct Visitor: NewsViewModelVisitor {

        var componentFactory: NewsComponentFactory

        func visit(_ announcement: AnnouncementComponentViewModel) {
            let component = componentFactory.makeAnnouncementComponent()
            component.setAnnouncementTitle(announcement.title)
        }

    }

    // MARK: Properties

    private let authenticationService: AuthenticationService
    private let delegate: NewsModuleDelegate
    private let newsScene: NewsScene
    private let newsInteractor: NewsInteractor
    private let privateMessagesService: PrivateMessagesService
    private let determineAuthStateOnce: DetermineAuthStateOnce

    // MARK: Initialization

    init(delegate: NewsModuleDelegate,
         newsScene: NewsScene,
         newsInteractor: NewsInteractor,
         authenticationService: AuthenticationService,
         privateMessagesService: PrivateMessagesService) {
        self.delegate = delegate
        self.newsScene = newsScene
        self.newsInteractor = newsInteractor
        self.authenticationService = authenticationService
        self.privateMessagesService = privateMessagesService

        determineAuthStateOnce = DetermineAuthStateOnce(authenticationService: authenticationService)

        newsScene.delegate = self
        authenticationService.add(observer: self)
        newsScene.showNewsTitle(.news)
    }

    // MARK: AuthStateObserver

    func userDidLogin(_ user: User) {
        newsScene.showMessagesNavigationAction()
        newsScene.hideLoginNavigationAction()
        newsScene.showWelcomePrompt(.welcomePrompt(for: user))
        newsScene.showWelcomeDescription("")
    }

    func userDidLogout() {
        newsScene.showLoginNavigationAction()
        newsScene.hideMessagesNavigationAction()
        newsScene.showLoginPrompt(.anonymousUserLoginPrompt)
        newsScene.showLoginDescription(.anonymousUserLoginDescription)
    }

    // MARK: PrivateMessageUnreadCountObserver

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        newsScene.showWelcomeDescription(.welcomeDescription(messageCount: unreadCount))
    }

    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [Message]) {

    }

    func privateMessagesServiceDidFailToLoadMessages() {

    }

    // MARK: NewsSceneDelegate

    func newsSceneWillAppear() {
        determineAuthStateOnce.run(authStateResolved)
        privateMessagesService.add(self)

        newsInteractor.prepareViewModel(interactorDidPrepareViewModel)
    }

    func newsSceneDidTapLoginAction(_ scene: NewsScene) {
        delegate.newsModuleDidRequestLogin()
    }

    func newsSceneDidTapShowMessagesAction(_ scene: NewsScene) {
        delegate.newsModuleDidRequestShowingPrivateMessages()
    }

    // MARK: Private

    private func interactorDidPrepareViewModel(_ viewModel: NewsViewModel) {
        let itemsPerComponent = (0..<viewModel.numberOfComponents).map(viewModel.numberOfItemsInComponent)
        let binder = Binder(viewModel: viewModel)
        newsScene.bind(numberOfItemsPerComponent: itemsPerComponent, using: binder)
    }

    private func authStateResolved(_ state: AuthState) {
        switch state {
        case .loggedIn(let user):
            userDidLogin(user)

        case .loggedOut:
            userDidLogout()
        }
    }

}
