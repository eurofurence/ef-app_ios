//
//  ApplicationDirector.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class ApplicationDirector: ExternalContentHandler,
                           RootModuleDelegate,
                           TutorialModuleDelegate,
                           PreloadModuleDelegate,
                           NewsModuleDelegate,
                           ScheduleModuleDelegate,
                           MessagesModuleDelegate,
                           LoginModuleDelegate,
                           DealersModuleDelegate,
                           KnowledgeListModuleDelegate,
                           KnowledgeDetailModuleDelegate {

    private class DissolveTransitionAnimationProviding: NSObject, UINavigationControllerDelegate {

        func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return ViewControllerDissolveTransitioning()
        }

    }

    private let animate: Bool
    private let linkLookupService: LinkLookupService
    private let urlOpener: URLOpener
    private let webModuleProviding: WebModuleProviding
    private let windowWireframe: WindowWireframe
    private let rootModuleProviding: RootModuleProviding
    private let tutorialModuleProviding: TutorialModuleProviding
    private let preloadModuleProviding: PreloadModuleProviding
    private let tabModuleProviding: TabModuleProviding
    private let newsModuleProviding: NewsModuleProviding
    private let scheduleModuleProviding: ScheduleModuleProviding
    private let dealersModuleProviding: DealersModuleProviding
    private let dealerDetailModuleProviding: DealerDetailModuleProviding
    private let collectThemAllModuleProviding: CollectThemAllModuleProviding
    private let messagesModuleProviding: MessagesModuleProviding
    private let loginModuleProviding: LoginModuleProviding
    private let messageDetailModuleProviding: MessageDetailModuleProviding
    private let knowledgeListModuleProviding: KnowledgeListModuleProviding
    private let knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    private let mapsModuleProviding: MapsModuleProviding
    private let announcementDetailModuleProviding: AnnouncementDetailModuleProviding
    private let eventDetailModuleProviding: EventDetailModuleProviding

    private let rootNavigationController: UINavigationController
    private let rootNavigationControllerDelegate = DissolveTransitionAnimationProviding()

    private var tabController: UIViewController?
    private var newsController: UIViewController?
    private let newsNavigationController: UINavigationController
    private let scheduleNavigationController: UINavigationController
    private let dealersNavigationController: UINavigationController
    private let knowledgeNavigationController: UINavigationController

    init(animate: Bool,
         linkLookupService: LinkLookupService,
         urlOpener: URLOpener,
         webModuleProviding: WebModuleProviding,
         windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         rootModuleProviding: RootModuleProviding,
         tutorialModuleProviding: TutorialModuleProviding,
         preloadModuleProviding: PreloadModuleProviding,
         tabModuleProviding: TabModuleProviding,
         newsModuleProviding: NewsModuleProviding,
         scheduleModuleProviding: ScheduleModuleProviding,
         dealersModuleProviding: DealersModuleProviding,
         dealerDetailModuleProviding: DealerDetailModuleProviding,
         collectThemAllModuleProviding: CollectThemAllModuleProviding,
         messagesModuleProviding: MessagesModuleProviding,
         loginModuleProviding: LoginModuleProviding,
         messageDetailModuleProviding: MessageDetailModuleProviding,
         knowledgeListModuleProviding: KnowledgeListModuleProviding,
         knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding,
         mapsModuleProviding: MapsModuleProviding,
         announcementDetailModuleProviding: AnnouncementDetailModuleProviding,
         eventDetailModuleProviding: EventDetailModuleProviding) {
        self.animate = animate
        self.linkLookupService = linkLookupService
        self.urlOpener = urlOpener
        self.webModuleProviding = webModuleProviding
        self.windowWireframe = windowWireframe
        self.rootModuleProviding = rootModuleProviding
        self.tutorialModuleProviding = tutorialModuleProviding
        self.preloadModuleProviding = preloadModuleProviding
        self.tabModuleProviding = tabModuleProviding
        self.newsModuleProviding = newsModuleProviding
        self.scheduleModuleProviding = scheduleModuleProviding
        self.dealersModuleProviding = dealersModuleProviding
        self.dealerDetailModuleProviding = dealerDetailModuleProviding
        self.collectThemAllModuleProviding = collectThemAllModuleProviding
        self.messagesModuleProviding = messagesModuleProviding
        self.loginModuleProviding = loginModuleProviding
        self.messageDetailModuleProviding = messageDetailModuleProviding
        self.knowledgeListModuleProviding = knowledgeListModuleProviding
        self.knowledgeDetailModuleProviding = knowledgeDetailModuleProviding
        self.mapsModuleProviding = mapsModuleProviding
        self.announcementDetailModuleProviding = announcementDetailModuleProviding
        self.eventDetailModuleProviding = eventDetailModuleProviding

        rootNavigationController = navigationControllerFactory.makeNavigationController()
        rootNavigationController.delegate = rootNavigationControllerDelegate
        rootNavigationController.isNavigationBarHidden = true
        windowWireframe.setRoot(rootNavigationController)

        newsNavigationController = navigationControllerFactory.makeNavigationController()
        scheduleNavigationController = navigationControllerFactory.makeNavigationController()
        dealersNavigationController = navigationControllerFactory.makeNavigationController()
        knowledgeNavigationController = navigationControllerFactory.makeNavigationController()

        rootModuleProviding.makeRootModule(self)
    }

    // MARK: ExternalContentHandler

    func handleExternalContent(url: URL) {
        let module = webModuleProviding.makeWebModule(for: url)
        tabController?.present(module, animated: true)
    }

    // MARK: RootModuleDelegate

    func rootModuleDidDetermineTutorialShouldBePresented() {
        showTutorial()
    }

    func rootModuleDidDetermineStoreShouldRefresh() {
        showPreloadModule()
    }

    func rootModuleDidDetermineRootModuleShouldBePresented() {
        showTabModule()
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
        showTabModule()
    }

    // MARK: NewsModuleDelegate

    func newsModuleDidRequestShowingPrivateMessages() {
        newsNavigationController.pushViewController(messagesModuleProviding.makeMessagesModule(self), animated: animate)
    }

    func newsModuleDidSelectAnnouncement(_ announcement: Announcement2) {
        let module = announcementDetailModuleProviding.makeAnnouncementDetailModule(for: announcement)
        newsNavigationController.pushViewController(module, animated: animate)
    }

    func newsModuleDidSelectEvent(_ event: Event2) {
        let module = eventDetailModuleProviding.makeEventDetailModule(for: event.identifier)
        newsNavigationController.pushViewController(module, animated: animate)
    }

    // MARK: ScheduleModuleDelegate

    func scheduleModuleDidSelectEvent(identifier: Event2.Identifier) {
        let module = eventDetailModuleProviding.makeEventDetailModule(for: identifier)
        scheduleNavigationController.pushViewController(module, animated: animate)
    }

    // MARK: MessagesModuleDelegate

    private var messagesModuleResolutionHandler: ((Bool) -> Void)?

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        messagesModuleResolutionHandler = completionHandler
        let loginModule = loginModuleProviding.makeLoginModule(self)
        loginModule.modalPresentationStyle = .formSheet

        let navigationController = UINavigationController(rootViewController: loginModule)
        tabController?.present(navigationController, animated: animate)
    }

    func messagesModuleDidRequestPresentation(for message: Message) {
        let viewController = messageDetailModuleProviding.makeMessageDetailModule(message: message)
        newsNavigationController.pushViewController(viewController, animated: animate)
    }

    func messagesModuleDidRequestDismissal() {
        guard let controller = newsController else { return }

        newsNavigationController.popToViewController(controller, animated: animate)
        tabController?.dismiss(animated: animate)
    }

    func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void) {
        let alert = UIAlertController(title: .loggingOut, message: .loggingOutAlertDetail, preferredStyle: .alert)
        tabController?.present(alert, animated: animate, completion: { presentedHandler({ alert.dismiss(animated: true) }) })
    }

    func showLogoutFailedAlert() {
        let alert = UIAlertController(title: .logoutFailed, message: .logoutFailedAlertDetail, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .cancel))
        tabController?.present(alert, animated: animate)
    }

    // MARK: LoginModuleDelegate

    func loginModuleDidCancelLogin() {
        messagesModuleResolutionHandler?(false)
    }

    func loginModuleDidLoginSuccessfully() {
        messagesModuleResolutionHandler?(true)
        tabController?.dismiss(animated: animate)
    }

    // MARK: DealersModuleDelegate

    func dealersModuleDidSelectDealer(identifier: Dealer2.Identifier) {
        let module = dealerDetailModuleProviding.makeDealerDetailModule(for: identifier)
        dealersNavigationController.pushViewController(module, animated: animate)
    }

    // MARK: KnowledgeListModuleDelegate

    func knowledgeListModuleDidSelectKnowledgeEntry(_ knowledgeEntry: KnowledgeEntry2) {
        let knowledgeDetailModule = knowledgeDetailModuleProviding.makeKnowledgeListModule(knowledgeEntry, delegate: self)
        knowledgeNavigationController.pushViewController(knowledgeDetailModule, animated: animate)
    }

    // MARK: KnowledgeDetailModuleDelegate

    func knowledgeDetailModuleDidSelectLink(_ link: Link) {
        guard let action = linkLookupService.lookupContent(for: link) else { return }

        switch action {
        case .web(let url):
            let webModule = webModuleProviding.makeWebModule(for: url)
            tabController?.present(webModule, animated: animate)

        case .externalURL(let url):
            urlOpener.open(url)
        }
    }

    // MARK: Private

    private func showPreloadModule() {
        let preloadViewController = preloadModuleProviding.makePreloadModule(self)
        rootNavigationController.setViewControllers([preloadViewController], animated: animate)
    }

    private func showTutorial() {
        let tutorialViewController = tutorialModuleProviding.makeTutorialModule(self)
        rootNavigationController.setViewControllers([tutorialViewController], animated: animate)
    }

    private func showTabModule() {
        let newsController = newsModuleProviding.makeNewsModule(self)
        self.newsController = newsController

        let knowledgeListController = knowledgeListModuleProviding.makeKnowledgeListModule(self)
        knowledgeNavigationController.setViewControllers([knowledgeListController], animated: animate)
        knowledgeNavigationController.tabBarItem = knowledgeListController.tabBarItem

        newsNavigationController.setViewControllers([newsController], animated: animate)
        newsNavigationController.tabBarItem = newsController.tabBarItem

        let scheduleViewController = scheduleModuleProviding.makeScheduleModule(self)
        scheduleNavigationController.setViewControllers([scheduleViewController], animated: animate)
        scheduleNavigationController.tabBarItem = scheduleViewController.tabBarItem

        let dealersViewController = dealersModuleProviding.makeDealersModule(self)
        dealersNavigationController.setViewControllers([dealersViewController], animated: animate)
        dealersNavigationController.tabBarItem = dealersViewController.tabBarItem

        let collectThemAllModule = collectThemAllModuleProviding.makeCollectThemAllModule()
        let collectThemAllNavigationController = UINavigationController(rootViewController: collectThemAllModule)
        collectThemAllNavigationController.tabBarItem = collectThemAllModule.tabBarItem

        let mapsModule = mapsModuleProviding.makeMapsModule()
        let mapsNavigationController = UINavigationController(rootViewController: mapsModule)
        mapsNavigationController.tabBarItem = mapsModule.tabBarItem

        let tabModule = tabModuleProviding.makeTabModule([newsNavigationController,
                                                          scheduleNavigationController,
                                                          dealersNavigationController,
                                                          collectThemAllNavigationController,
                                                          knowledgeNavigationController,
                                                          mapsNavigationController])
        tabController = tabModule

        rootNavigationController.setViewControllers([tabModule], animated: animate)
    }

}
