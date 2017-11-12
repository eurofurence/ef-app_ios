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
                           MessagesModuleDelegate {

    private let windowWireframe: WindowWireframe
    private let rootModuleFactory: RootModuleFactory
    private let tutorialModuleFactory: TutorialModuleFactory
    private let preloadModuleFactory: PreloadModuleFactory
    private let tabModuleFactory: TabModuleFactory
    private let newsModuleFactory: NewsModuleFactory
    private let messagesModuleFactory: MessagesModuleFactory
    private let newsNavigationController: UINavigationController

    private var newsController: UIViewController?

    init(windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         rootModuleFactory: RootModuleFactory,
         tutorialModuleFactory: TutorialModuleFactory,
         preloadModuleFactory: PreloadModuleFactory,
         tabModuleFactory: TabModuleFactory,
         newsModuleFactory: NewsModuleFactory,
         messagesModuleFactory: MessagesModuleFactory) {
        self.windowWireframe = windowWireframe
        self.rootModuleFactory = rootModuleFactory
        self.tutorialModuleFactory = tutorialModuleFactory
        self.preloadModuleFactory = preloadModuleFactory
        self.tabModuleFactory = tabModuleFactory
        self.newsModuleFactory = newsModuleFactory
        self.messagesModuleFactory = messagesModuleFactory

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

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {

    }

    func messagesModuleDidRequestDismissal() {
        guard let controller = newsController else { return }
        newsNavigationController.popToViewController(controller, animated: true)
    }

    // MARK: Private

    private func showPreloadModule() {
        windowWireframe.setRoot(preloadModuleFactory.makePreloadModule(self))
    }

    private func showTutorial() {
        windowWireframe.setRoot(tutorialModuleFactory.makeTutorialModule(self))
    }

}
