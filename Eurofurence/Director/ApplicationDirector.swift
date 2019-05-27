import EurofurenceModel
import UIKit

class ApplicationDirector: ExternalContentHandler,
                           RootModuleDelegate,
                           TutorialModuleDelegate,
                           PreloadModuleDelegate,
                           NewsModuleDelegate,
                           ScheduleModuleDelegate,
                           EventDetailModuleDelegate,
                           MessagesModuleDelegate,
                           LoginModuleDelegate,
                           DealersModuleDelegate,
                           KnowledgeGroupsListModuleDelegate,
                           KnowledgeGroupEntriesModuleDelegate,
                           KnowledgeDetailModuleDelegate,
                           MapsModuleDelegate,
                           MapDetailModuleDelegate,
                           AnnouncementsModuleDelegate,
                           EventFeedbackModuleDelegate {

    private class SaveTabOrderWhenCustomizationFinishes: NSObject, UITabBarControllerDelegate {

        private let orderingPolicy: ModuleOrderingPolicy

        init(orderingPolicy: ModuleOrderingPolicy) {
            self.orderingPolicy = orderingPolicy
        }

        func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
            orderingPolicy.saveOrder(viewControllers)
        }

    }
    
    private var performAnimations: Bool {
        return animate && UIApplication.shared.applicationState == .active
    }

    private let animate: Bool
    private let moduleRepository: ModuleRepository
    private let navigationControllerFactory: NavigationControllerFactory
    private let tabModuleProviding: TabModuleProviding
    private let linkLookupService: ContentLinksService
    private let urlOpener: URLOpener
    private let orderingPolicy: ModuleOrderingPolicy
    private let windowWireframe: WindowWireframe
    private let notificationService: NotificationService

    private var newsController: UIViewController?
    private var scheduleViewController: UIViewController?
    private var knowledgeListController: UIViewController?
    private var dealersViewController: UIViewController?
    private var mapsModule: UIViewController?

    private var tabController: UITabBarController?

    private let saveTabOrder: SaveTabOrderWhenCustomizationFinishes
    
    init(animate: Bool,
         moduleRepository: ModuleRepository,
         linkLookupService: ContentLinksService,
         urlOpener: URLOpener,
         orderingPolicy: ModuleOrderingPolicy,
         windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         tabModuleProviding: TabModuleProviding,
         notificationHandling: NotificationService) {
        self.animate = animate
        self.moduleRepository = moduleRepository
        self.navigationControllerFactory = navigationControllerFactory
        self.tabModuleProviding = tabModuleProviding
        self.linkLookupService = linkLookupService
        self.urlOpener = urlOpener
        self.orderingPolicy = orderingPolicy
        self.windowWireframe = windowWireframe
        self.notificationService = notificationHandling

        saveTabOrder = SaveTabOrderWhenCustomizationFinishes(orderingPolicy: orderingPolicy)

        moduleRepository.makeRootModule(self)
    }

    // MARK: Public
    
    func openAnnouncement(_ announcement: AnnouncementIdentifier) {
        guard let newsNavigationController = newsController?.navigationController,
              let tabBarController = tabController,
              let index = tabBarController.viewControllers?.firstIndex(of: newsNavigationController) else { return }
        
        let module = moduleRepository.makeAnnouncementDetailModule(for: announcement)
        tabBarController.selectedIndex = index
        newsNavigationController.pushViewController(module, animated: performAnimations)
    }
    
    func openEvent(_ event: EventIdentifier) {
        guard let scheduleViewController = scheduleViewController,
              let scheduleNavigationController = scheduleViewController.navigationController,
              let tabBarController = tabController,
              let index = tabBarController.viewControllers?.firstIndex(of: scheduleNavigationController) else { return }
        
        let module = moduleRepository.makeEventDetailModule(for: event, delegate: self)
        tabBarController.selectedIndex = index
        scheduleNavigationController.setViewControllers([scheduleViewController, module], animated: performAnimations)
    }
    
    func showInvalidatedAnnouncementAlert() {
        let alert = UIAlertController(title: .invalidAnnouncementAlertTitle,
                                      message: .invalidAnnouncementAlertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .cancel))
        tabController?.present(alert, animated: performAnimations, completion: nil)
    }

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
                let module = self.moduleRepository.makeAnnouncementDetailModule(for: announcement)
                if  let newsNavigationController = self.newsController?.navigationController,
                    let tabBarController = self.tabController,
                    let index = tabBarController.viewControllers?.firstIndex(of: newsNavigationController) {
                    tabBarController.selectedIndex = index
                    newsNavigationController.pushViewController(module, animated: self.performAnimations)
                }

                completionHandler()

            case .invalidatedAnnouncement:
                let alert = UIAlertController(title: .invalidAnnouncementAlertTitle,
                                              message: .invalidAnnouncementAlertMessage,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: .ok, style: .cancel))
                self.tabController?.present(alert, animated: self.performAnimations, completion: nil)

                completionHandler()

            case .event(let event):
                let module = self.moduleRepository.makeEventDetailModule(for: event, delegate: self)
                if  let scheduleNavigationController = self.scheduleViewController?.navigationController,
                    let tabBarController = self.tabController,
                    let index = tabBarController.viewControllers?.firstIndex(of: scheduleNavigationController),
                    let scheduleViewController = self.scheduleViewController {
                    tabBarController.selectedIndex = index
                    scheduleNavigationController.setViewControllers([scheduleViewController, module], animated: self.performAnimations)
                }

                completionHandler()

            case .unknown:
                completionHandler()
            }
        }
    }

    // MARK: ExternalContentHandler

    func handleExternalContent(url: URL) {
        let module = moduleRepository.makeWebModule(for: url)
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
        newsController?.navigationController?.pushViewController(moduleRepository.makeMessagesModule(self), animated: animate)
    }

    func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        let module = moduleRepository.makeAnnouncementDetailModule(for: announcement)
        newsController?.navigationController?.pushViewController(module, animated: animate)
    }

    func newsModuleDidSelectEvent(_ event: Event) {
        let module = moduleRepository.makeEventDetailModule(for: event.identifier, delegate: self)
        newsController?.navigationController?.pushViewController(module, animated: animate)
    }

    func newsModuleDidRequestShowingAllAnnouncements() {
        let module = moduleRepository.makeAnnouncementsModule(self)
        newsController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: ScheduleModuleDelegate

    func scheduleModuleDidSelectEvent(identifier: EventIdentifier) {
        let module = moduleRepository.makeEventDetailModule(for: identifier, delegate: self)
        scheduleViewController?.navigationController?.pushViewController(module, animated: animate)
    }
    
    // MARK: EventDetailModuleDelegate
    
    private var presentedFeedbackViewController: UIViewController?
    
    func eventDetailModuleDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        let module = moduleRepository.makeEventFeedbackModule(for: event, delegate: self)
        let navigationController = navigationControllerFactory.makeNavigationController()
        navigationController.setViewControllers([module], animated: false)
        navigationController.modalPresentationStyle = .formSheet
        presentedFeedbackViewController = navigationController
        
        scheduleViewController?.navigationController?.present(navigationController, animated: animate)
    }
    
    // MARK: EventFeedbackModuleDelegate
    
    func eventFeedbackDismissed() {
        presentedFeedbackViewController?.dismiss(animated: animate)
        presentedFeedbackViewController = nil
    }

    // MARK: MessagesModuleDelegate

    private var messagesModuleResolutionHandler: ((Bool) -> Void)?

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        messagesModuleResolutionHandler = completionHandler
        let loginModule = moduleRepository.makeLoginModule(self)
        loginModule.modalPresentationStyle = .formSheet

        let navigationController = UINavigationController(rootViewController: loginModule)
        navigationController.modalPresentationStyle = .formSheet
        tabController?.present(navigationController, animated: animate)
    }

    func messagesModuleDidRequestPresentation(for message: Message) {
        let viewController = moduleRepository.makeMessageDetailModule(message: message)
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
        let module = moduleRepository.makeDealerDetailModule(for: identifier)
        dealersViewController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: KnowledgeGroupsListModuleDelegate

    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        let module = moduleRepository.makeKnowledgeGroupEntriesModule(knowledgeGroup, delegate: self)
        knowledgeListController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: KnowledgeGroupEntriesModuleDelegate

    func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        let knowledgeDetailModule = moduleRepository.makeKnowledgeDetailModule(identifier, delegate: self)
        knowledgeListController?.navigationController?.pushViewController(knowledgeDetailModule, animated: animate)
    }

    // MARK: KnowledgeDetailModuleDelegate

    func knowledgeDetailModuleDidSelectLink(_ link: Link) {
        guard let action = linkLookupService.lookupContent(for: link) else { return }

        switch action {
        case .web(let url):
            let webModule = moduleRepository.makeWebModule(for: url)
            tabController?.present(webModule, animated: animate)

        case .externalURL(let url):
            urlOpener.open(url)
        }
    }

    // MARK: MapsModuleDelegate

    func mapsModuleDidSelectMap(identifier: MapIdentifier) {
        let detailModule = moduleRepository.makeMapDetailModule(for: identifier, delegate: self)
        mapsModule?.navigationController?.pushViewController(detailModule, animated: animate)
    }

    // MARK: MapDetailModuleDelegate

    func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
        let module = moduleRepository.makeDealerDetailModule(for: identifier)
        mapsModule?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: AnnouncementsModuleDelegate

    func announcementsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        let module = moduleRepository.makeAnnouncementDetailModule(for: announcement)
        newsController?.navigationController?.pushViewController(module, animated: animate)
    }

    // MARK: Private

    private func showPreloadModule() {
        let preloadViewController = moduleRepository.makePreloadModule(self)
        windowWireframe.setRoot(preloadViewController)
    }

    private func showTutorial() {
        let tutorialViewController = moduleRepository.makeTutorialModule(self)
        windowWireframe.setRoot(tutorialViewController)
    }

    private func showTabModule() {
        let moduleControllers = makeTabNavigationControllers()
        applyRestorationIdentifiers(moduleControllers)

        let orderedModules = orderingPolicy.order(modules: moduleControllers)
        let tabModule = tabModuleProviding.makeTabModule(orderedModules)
        tabController = tabModule
        tabModule.delegate = saveTabOrder

        windowWireframe.setRoot(tabModule)
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
        let newsController = moduleRepository.makeNewsModule(self)
        self.newsController = newsController
        navigationController.setViewControllers([newsController], animated: animate)
        navigationController.tabBarItem = newsController.tabBarItem

        return navigationController
    }

    private func makeScheduleNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let scheduleViewController = moduleRepository.makeScheduleModule(self)
        self.scheduleViewController = scheduleViewController
        navigationController.setViewControllers([scheduleViewController], animated: animate)
        navigationController.tabBarItem = scheduleViewController.tabBarItem

        return navigationController
    }

    private func makeDealersNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let dealersViewController = moduleRepository.makeDealersModule(self)
        self.dealersViewController = dealersViewController
        navigationController.setViewControllers([dealersViewController], animated: animate)
        navigationController.tabBarItem = dealersViewController.tabBarItem

        return navigationController
    }

    private func makeKnowledgeNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let knowledgeListController = moduleRepository.makeKnowledgeListModule(self)
        self.knowledgeListController = knowledgeListController
        navigationController.setViewControllers([knowledgeListController], animated: animate)
        navigationController.tabBarItem = knowledgeListController.tabBarItem

        return navigationController
    }

    private func makeMapsNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let mapsModule = moduleRepository.makeMapsModule(self)
        self.mapsModule = mapsModule
        navigationController.setViewControllers([mapsModule], animated: animate)
        navigationController.tabBarItem = mapsModule.tabBarItem

        return navigationController
    }

    private func makeCollectThemAllNavigationController() -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        let collectThemAllModule = moduleRepository.makeCollectThemAllModule()
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
