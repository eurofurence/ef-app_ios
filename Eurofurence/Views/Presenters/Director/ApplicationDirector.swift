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
    private let rootModuleProviding: RootModuleProviding
    private let tutorialModuleProviding: TutorialModuleProviding
    private let preloadModuleProviding: PreloadModuleProviding
    private let tabModuleProviding: TabModuleProviding
    private let newsModuleProviding: NewsModuleProviding
    private let messagesModuleProviding: MessagesModuleProviding
    private let newsNavigationController: UINavigationController
    private let loginModuleProviding: LoginModuleProviding

    private var tabController: UIViewController?
    private var newsController: UIViewController?

    init(windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         rootModuleProviding: RootModuleProviding,
         tutorialModuleProviding: TutorialModuleProviding,
         preloadModuleProviding: PreloadModuleProviding,
         tabModuleProviding: TabModuleProviding,
         newsModuleProviding: NewsModuleProviding,
         messagesModuleProviding: MessagesModuleProviding,
         loginModuleProviding: LoginModuleProviding) {
        self.windowWireframe = windowWireframe
        self.rootModuleProviding = rootModuleProviding
        self.tutorialModuleProviding = tutorialModuleProviding
        self.preloadModuleProviding = preloadModuleProviding
        self.tabModuleProviding = tabModuleProviding
        self.newsModuleProviding = newsModuleProviding
        self.messagesModuleProviding = messagesModuleProviding
        self.loginModuleProviding = loginModuleProviding

        newsNavigationController = navigationControllerFactory.makeNavigationController()

        rootModuleProviding.makeRootModule(self)
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
        let newsController = newsModuleProviding.makeNewsModule(self)
        self.newsController = newsController

        newsNavigationController.setViewControllers([newsController], animated: false)
        let tabModule = tabModuleProviding.makeTabModule([newsNavigationController])
        tabController = tabModule

        windowWireframe.setRoot(tabModule)
    }

    // MARK: NewsModuleDelegate

    func newsModuleDidRequestLogin() {
        newsNavigationController.pushViewController(messagesModuleProviding.makeMessagesModule(self), animated: true)
    }

    func newsModuleDidRequestShowingPrivateMessages() {
        newsNavigationController.pushViewController(messagesModuleProviding.makeMessagesModule(self), animated: true)
    }

    // MARK: MessagesModuleDelegate

    private var messagesModuleResolutionHandler: ((Bool) -> Void)?

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        messagesModuleResolutionHandler = completionHandler
        let loginModule = loginModuleProviding.makeLoginModule(self)
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

    func loginModuleDidLoginSuccessfully() {
        messagesModuleResolutionHandler?(true)
    }

    // MARK: Private

    private func showPreloadModule() {
        windowWireframe.setRoot(preloadModuleProviding.makePreloadModule(self))
    }

    private func showTutorial() {
        windowWireframe.setRoot(tutorialModuleProviding.makeTutorialModule(self))
    }

}
