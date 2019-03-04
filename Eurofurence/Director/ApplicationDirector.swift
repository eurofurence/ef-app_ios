//
//  ApplicationDirector.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
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
                           KnowledgeGroupsListModuleDelegate,
                           KnowledgeGroupEntriesModuleDelegate,
                           KnowledgeDetailModuleDelegate,
                           MapsModuleDelegate,
                           MapDetailModuleDelegate,
                           AnnouncementsModuleDelegate {

    private class DissolveTransitionAnimationProviding: NSObject, UINavigationControllerDelegate {

        // swiftlint:disable line_length
        func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return ViewControllerDissolveTransitioning()
        }

    }

    private class SaveTabOrderWhenCustomizationFinishes: NSObject, UITabBarControllerDelegate {

        private let orderingPolicy: ModuleOrderingPolicy

        init(orderingPolicy: ModuleOrderingPolicy) {
            self.orderingPolicy = orderingPolicy
        }

        func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
            orderingPolicy.saveOrder(viewControllers)
        }

    }

    private let animate: Bool
    private let navigationControllerFactory: NavigationControllerFactory
    private let linkLookupService: ContentLinksService
    private let urlOpener: URLOpener
    private let orderingPolicy: ModuleOrderingPolicy
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
    private let knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding
    private let knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding
    private let knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    private let mapsModuleProviding: MapsModuleProviding
    private let mapDetailModuleProviding: MapDetailModuleProviding
    private let announcementsModuleFactory: AnnouncementsModuleProviding
    private let announcementDetailModuleProviding: AnnouncementDetailModuleProviding
    private let eventDetailModuleProviding: EventDetailModuleProviding
    private let notificationService: NotificationService

    private let rootNavigationController: UINavigationController
    private let rootNavigationControllerDelegate = DissolveTransitionAnimationProviding()

    private var newsController: UIViewController?
    private var scheduleViewController: UIViewController?
    private var knowledgeListController: UIViewController?
    private var dealersViewController: UIViewController?
    private var mapsModule: UIViewController?

    private var tabController: UITabBarController?

    private let saveTabOrder: SaveTabOrderWhenCustomizationFinishes

    init(animate: Bool,
         linkLookupService: ContentLinksService,
         urlOpener: URLOpener,
         orderingPolicy: ModuleOrderingPolicy,
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
         knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding,
         knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding,
         knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding,
         mapsModuleProviding: MapsModuleProviding,
         mapDetailModuleProviding: MapDetailModuleProviding,
         announcementsModuleFactory: AnnouncementsModuleProviding,
         announcementDetailModuleProviding: AnnouncementDetailModuleProviding,
         eventDetailModuleProviding: EventDetailModuleProviding,
         notificationHandling: NotificationService) {
        self.animate = animate
        self.navigationControllerFactory = navigationControllerFactory
        self.linkLookupService = linkLookupService
        self.urlOpener = urlOpener
        self.orderingPolicy = orderingPolicy
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
        self.knowledgeGroupEntriesModule = knowledgeGroupEntriesModule
        self.knowledgeDetailModuleProviding = knowledgeDetailModuleProviding
        self.mapsModuleProviding = mapsModuleProviding
        self.announcementsModuleFactory = announcementsModuleFactory
        self.mapDetailModuleProviding = mapDetailModuleProviding
        self.announcementDetailModuleProviding = announcementDetailModuleProviding
        self.eventDetailModuleProviding = eventDetailModuleProviding
        self.notificationService = notificationHandling

        saveTabOrder = SaveTabOrderWhenCustomizationFinishes(orderingPolicy: orderingPolicy)

        rootNavigationController = navigationControllerFactory.makeNavigationController()
        rootNavigationController.delegate = rootNavigationControllerDelegate
        rootNavigationController.isNavigationBarHidden = true
        windowWireframe.setRoot(rootNavigationController)

        rootModuleProviding.makeRootModule(self)
    }

    // MARK: Public

    func openNotification(_ payload: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        let castedPayloadKeysAndValues = payload.compactMap { (key, value) -> (String, String)? in
            guard let stringKey = key as? String, let stringValue = value as? String else { return nil }
            return (stringKey, stringValue)
        }

        let castedPayload = castedPayloadKeysAndValues.reduce(into: [String: String](), { $0[$1.0] = $1.1 })

        notificationService.handleNotification(payload: castedPayload) { (content) in
            switch content {
            case .successfulSync:
                completionHandler()

            case .failedSync:
                completionHandler()

            case .announcement(let announcement):
                let module = self.announcementDetailModuleProviding.makeAnnouncementDetailModule(for: announcement)
                if  let newsNavigationController = self.newsController?.navigationController,
                    let tabBarController = self.tabController,
                    let index = tabBarController.viewControllers?.index(of: newsNavigationController) {
                    tabBarController.selectedIndex = index
                    newsNavigationController.pushViewController(module, animated: self.animate)
                }

                completionHandler()

            case .invalidatedAnnouncement:
                let alert = UIAlertController(title: .invalidAnnouncementAlertTitle,
                                              message: .invalidAnnouncementAlertMessage,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: .ok, style: .cancel))
                self.tabController?.present(alert, animated: self.animate, completion: nil)

                completionHandler()

            case .event(let event):
                let module = self.eventDetailModuleProviding.makeEventDetailModule(for: event)
                if  let scheduleNavigationController = self.scheduleViewController?.navigationController,
                    let tabBarController = self.tabController,
                    let index = tabBarController.viewControllers?.index(of: scheduleNavigationController) {
                    tabBarController.selectedIndex = index
                    scheduleNavigationController.pushViewController(module, animated: self.animate)
                }

                completionHandler()

            case .unknown:
                completionHandler()
            }
        }
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
        newsController?.navigationController?.pushViewController(messagesModuleProviding.makeMessagesModule(self), animated: animate)
    }

    func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        let module = announcementDetailModuleProviding.makeAnnouncementDetailModule(for: announcement)
        newsController?.navigationController?.pushViewController(module, animated: animate)
    }

    func newsModuleDidSelectEvent(_ event: Event) {
        let module = eventDetailModuleProviding.makeEventDetailModule(for: event.identifier)
        newsController?.navigationController?.pushViewController(module, animated: animate)
    }

    func newsModuleDidRequestShowingAllAnnouncements() {
        let module = announcementsModuleFactory.makeAnnouncementsModule(self)
        newsController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: ScheduleModuleDelegate

    func scheduleModuleDidSelectEvent(identifier: EventIdentifier) {
        let module = eventDetailModuleProviding.makeEventDetailModule(for: identifier)
        scheduleViewController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: MessagesModuleDelegate

    private var messagesModuleResolutionHandler: ((Bool) -> Void)?

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        messagesModuleResolutionHandler = completionHandler
        let loginModule = loginModuleProviding.makeLoginModule(self)
        loginModule.modalPresentationStyle = .formSheet

        let navigationController = UINavigationController(rootViewController: loginModule)
        navigationController.modalPresentationStyle = .formSheet
        tabController?.present(navigationController, animated: animate)
    }

    func messagesModuleDidRequestPresentation(for message: Message) {
        let viewController = messageDetailModuleProviding.makeMessageDetailModule(message: message)
        newsController?.navigationController?.pushViewController(viewController, animated: animate)
    }

    func messagesModuleDidRequestDismissal() {
        guard let controller = newsController else { return }

        newsController?.navigationController?.popToViewController(controller, animated: animate)
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

    func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        let module = dealerDetailModuleProviding.makeDealerDetailModule(for: identifier)
        dealersViewController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: KnowledgeGroupsListModuleDelegate

    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        let module = knowledgeGroupEntriesModule.makeKnowledgeGroupEntriesModule(knowledgeGroup, delegate: self)
        knowledgeListController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: KnowledgeGroupEntriesModuleDelegate

    func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        let knowledgeDetailModule = knowledgeDetailModuleProviding.makeKnowledgeListModule(identifier, delegate: self)
        knowledgeListController?.navigationController?.pushViewController(knowledgeDetailModule, animated: animate)
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

    // MARK: MapsModuleDelegate

    func mapsModuleDidSelectMap(identifier: MapIdentifier) {
        let detailModule = mapDetailModuleProviding.makeMapDetailModule(for: identifier, delegate: self)
        mapsModule?.navigationController?.pushViewController(detailModule, animated: animate)
    }

    // MARK: MapDetailModuleDelegate

    func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
        let module = dealerDetailModuleProviding.makeDealerDetailModule(for: identifier)
        mapsModule?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: AnnouncementsModuleDelegate

    func announcementsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        let module = announcementDetailModuleProviding.makeAnnouncementDetailModule(for: announcement)
        newsController?.navigationController?.pushViewController(module, animated: animate)
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
        let moduleControllers = makeTabNavigationControllers()
        applyRestorationIdentifiers(moduleControllers)

        let orderedModules = orderingPolicy.order(modules: moduleControllers)
        let tabModule = tabModuleProviding.makeTabModule(orderedModules)
        tabController = tabModule
        tabModule.delegate = saveTabOrder

        rootNavigationController.setViewControllers([tabModule], animated: animate)
    }

    private func makeTabNavigationControllers() -> [UINavigationController] {
        return [makeNewsNavigationController(),
                makeScheduleNavigationController(),
                makeDealersNavigationController(),
                makeKnowledgeNavigationController(),
                makeMapsNavigationController(),
                makeCollectThemAllNavigationController()]
    }

    private func makeNewsNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let newsController = newsModuleProviding.makeNewsModule(self)
        self.newsController = newsController
        navigationController.setViewControllers([newsController], animated: animate)
        navigationController.tabBarItem = newsController.tabBarItem

        return navigationController
    }

    private func makeScheduleNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let scheduleViewController = scheduleModuleProviding.makeScheduleModule(self)
        self.scheduleViewController = scheduleViewController
        navigationController.setViewControllers([scheduleViewController], animated: animate)
        navigationController.tabBarItem = scheduleViewController.tabBarItem

        return navigationController
    }

    private func makeDealersNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let dealersViewController = dealersModuleProviding.makeDealersModule(self)
        self.dealersViewController = dealersViewController
        navigationController.setViewControllers([dealersViewController], animated: animate)
        navigationController.tabBarItem = dealersViewController.tabBarItem

        return navigationController
    }

    private func makeKnowledgeNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let knowledgeListController = knowledgeListModuleProviding.makeKnowledgeListModule(self)
        self.knowledgeListController = knowledgeListController
        navigationController.setViewControllers([knowledgeListController], animated: animate)
        navigationController.tabBarItem = knowledgeListController.tabBarItem

        return navigationController
    }

    private func makeMapsNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let mapsModule = mapsModuleProviding.makeMapsModule(self)
        self.mapsModule = mapsModule
        navigationController.setViewControllers([mapsModule], animated: animate)
        navigationController.tabBarItem = mapsModule.tabBarItem

        return navigationController
    }

    private func makeCollectThemAllNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let collectThemAllModule = collectThemAllModuleProviding.makeCollectThemAllModule()
        navigationController.setViewControllers([collectThemAllModule], animated: animate)
        navigationController.tabBarItem = collectThemAllModule.tabBarItem

        return navigationController
    }

    private func applyRestorationIdentifiers(_ moduleControllers: [UINavigationController]) {
        moduleControllers.forEach { (navigationController) in
            guard let identifier = navigationController.topViewController?.restorationIdentifier else { return }
            navigationController.restorationIdentifier = "NAV_" + identifier
        }
    }

}
