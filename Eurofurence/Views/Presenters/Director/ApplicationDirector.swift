//
//  ApplicationDirector.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class ApplicationDirector: RootModuleDelegate,
                           TutorialModuleDelegate,
                           PreloadModuleDelegate,
                           NewsModuleDelegate,
                           MessagesModuleDelegate,
                           LoginModuleDelegate {

    private let windowWireframe: WindowWireframe
    private let rootModuleFactory: RootModuleFactory
    private let tutorialModuleFactory: TutorialModuleFactory
    private let preloadModuleFactory: PreloadModuleFactory
    private let tabModuleFactory: TabModuleFactory
    private let newsModuleFactory: NewsModuleFactory
    private let messagesModuleFactory: MessagesModuleFactory
    private let newsNavigationController: UINavigationController
    private let loginModuleFactory: LoginModuleFactory

    private var tabController: UIViewController?
    private var newsController: UIViewController?

    init(windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         rootModuleFactory: RootModuleFactory,
         tutorialModuleFactory: TutorialModuleFactory,
         preloadModuleFactory: PreloadModuleFactory,
         tabModuleFactory: TabModuleFactory,
         newsModuleFactory: NewsModuleFactory,
         messagesModuleFactory: MessagesModuleFactory,
         loginModuleFactory: LoginModuleFactory) {
        self.windowWireframe = windowWireframe
        self.rootModuleFactory = rootModuleFactory
        self.tutorialModuleFactory = tutorialModuleFactory
        self.preloadModuleFactory = preloadModuleFactory
        self.tabModuleFactory = tabModuleFactory
        self.newsModuleFactory = newsModuleFactory
        self.messagesModuleFactory = messagesModuleFactory
        self.loginModuleFactory = loginModuleFactory

        newsNavigationController = navigationControllerFactory.makeNavigationController()

        rootModuleFactory.makeRootModule(self)
    }

    // MARK: RootModuleDelegate

    func userNeedsToWitnessTutorial() {
        showTutorial()
    }

    func storeShouldBePreloaded() {
        showPreloadModule()
    }

    // MARK: TutorialModuleDelegate

    func tutorialModuleDidFinishPresentingTutorial() {
        showPreloadModule()
    }

    // MARK: PreloadModuleDelegate

    func preloadModuleDidCancelPreloading() {
        showTutorial()
    }

    func preloadModuleDidFinishPreloading() {
        let newsController = newsModuleFactory.makeNewsModule(self)
        self.newsController = newsController

        newsNavigationController.setViewControllers([newsController], animated: false)
        let tabModule = tabModuleFactory.makeTabModule([newsNavigationController])
        tabController = tabModule

        windowWireframe.setRoot(tabModule)
    }

    // MARK: NewsModuleDelegate

    func newsModuleDidRequestLogin() {
        newsNavigationController.pushViewController(messagesModuleFactory.makeMessagesModule(self), animated: true)
    }

    func newsModuleDidRequestShowingPrivateMessages() {
        newsNavigationController.pushViewController(messagesModuleFactory.makeMessagesModule(self), animated: true)
    }

    // MARK: MessagesModuleDelegate

    private var messagesModuleResolutionHandler: ((Bool) -> Void)?

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        messagesModuleResolutionHandler = completionHandler
        let loginModule = loginModuleFactory.makeLoginModule(self)
        loginModule.modalPresentationStyle = .formSheet

        tabController?.present(loginModule, animated: true)
    }

    func messagesModuleDidRequestPresentation(for message: Message) {

    }

    func messagesModuleDidRequestDismissal() {
        guard let controller = newsController else { return }
        newsNavigationController.popToViewController(controller, animated: true)
    }

    // MARK: LoginModuleDelegate

    func loginModuleDidCancelLogin() {
        messagesModuleResolutionHandler?(false)
    }

    // MARK: Private

    private func showPreloadModule() {
        windowWireframe.setRoot(preloadModuleFactory.makePreloadModule(self))
    }

    private func showTutorial() {
        windowWireframe.setRoot(tutorialModuleFactory.makeTutorialModule(self))
    }

}
