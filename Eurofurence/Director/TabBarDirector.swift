import EurofurenceModel
import UIKit

class TabBarDirector: NewsModuleDelegate, ScheduleModuleDelegate,
                      EventDetailModuleDelegate, MessagesModuleDelegate, LoginModuleDelegate,
                      DealersModuleDelegate, KnowledgeGroupsListModuleDelegate, KnowledgeGroupEntriesModuleDelegate,
                      KnowledgeDetailModuleDelegate, MapsModuleDelegate, MapDetailModuleDelegate,
                      AnnouncementsModuleDelegate, EventFeedbackModuleDelegate {
    
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
    private let newsDelegate: NewsModuleDelegate?
    
    private var tabController: UITabBarController?
    private var newsController: UIViewController?
    private var scheduleViewController: UIViewController?
    private var knowledgeListController: UIViewController?
    private var dealersViewController: UIViewController?
    private var mapsModule: UIViewController?
    
    private let saveTabOrder: SaveTabOrderWhenCustomizationFinishes
    
    init(animate: Bool,
         moduleRepository: ModuleRepository,
         linkLookupService: ContentLinksService,
         urlOpener: URLOpener,
         orderingPolicy: ModuleOrderingPolicy,
         windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         tabModuleProviding: TabModuleProviding,
         newsDelegate: NewsModuleDelegate?) {
        self.animate = animate
        self.moduleRepository = moduleRepository
        self.navigationControllerFactory = navigationControllerFactory
        self.tabModuleProviding = tabModuleProviding
        self.linkLookupService = linkLookupService
        self.urlOpener = urlOpener
        self.orderingPolicy = orderingPolicy
        self.windowWireframe = windowWireframe
        self.newsDelegate = newsDelegate
        
        saveTabOrder = SaveTabOrderWhenCustomizationFinishes(orderingPolicy: orderingPolicy)
        
        let moduleControllers = makeTabNavigationControllers()
        applyRestorationIdentifiers(moduleControllers)
        
        let orderedModules = orderingPolicy.order(modules: moduleControllers)
        let tabModule = tabModuleProviding.makeTabModule(orderedModules)
        tabController = tabModule
        tabModule.delegate = saveTabOrder
        windowWireframe.setRoot(tabModule)
    }
    
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
    
    func openDealer(_ dealer: DealerIdentifier) {
        guard let dealersViewController = dealersViewController,
            let dealerNavigationController = dealersViewController.navigationController,
            let tabBarController = tabController,
            let index = tabBarController.viewControllers?.firstIndex(of: dealerNavigationController) else { return }
        
        let module = moduleRepository.makeDealerDetailModule(for: dealer)
        tabBarController.selectedIndex = index
        dealerNavigationController.pushViewController(module, animated: performAnimations)
    }
    
    func openMessage(_ message: MessageIdentifier) {
        openMessage(message, revealStyle: .replace)
    }
    
    func openKnowledgeGroups() {
        guard let knowledgeNavigationController = knowledgeListController?.navigationController else { return }
        
        if let index = tabController?.viewControllers?.firstIndex(of: knowledgeNavigationController),
           let knowledgeListController = knowledgeListController {        
            tabController?.selectedIndex = index
            knowledgeNavigationController.setViewControllers([knowledgeListController], animated: false)
        }
    }
    
    func openKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier) {
        guard let knowledgeNavigationController = knowledgeListController?.navigationController else { return }
        
        if let index = tabController?.viewControllers?.firstIndex(of: knowledgeNavigationController),
           let knowledgeListController = knowledgeListController {
            tabController?.selectedIndex = index
            
            let knowledgeDetailModule = moduleRepository.makeKnowledgeDetailModule(knowledgeEntry, delegate: self)
            knowledgeNavigationController.setViewControllers([knowledgeListController, knowledgeDetailModule], animated: animate)
        }
    }
    
    func showInvalidatedAnnouncementAlert() {
        let alert = UIAlertController(title: .invalidAnnouncementAlertTitle,
                                      message: .invalidAnnouncementAlertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .cancel))
        tabController?.present(alert, animated: performAnimations, completion: nil)
    }
    
    func openKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier, parentGroup: KnowledgeGroupIdentifier) {
        guard let knowledgeNavigationController = knowledgeListController?.navigationController else { return }
        
        if let index = tabController?.viewControllers?.firstIndex(of: knowledgeNavigationController),
            let knowledgeListController = knowledgeListController {
            tabController?.selectedIndex = index
            
            let knowledgeGroupModule = moduleRepository.makeKnowledgeGroupEntriesModule(parentGroup, delegate: self)
            let knowledgeEntryModule = moduleRepository.makeKnowledgeDetailModule(knowledgeEntry, delegate: self)
            let viewControllers = [knowledgeListController, knowledgeGroupModule, knowledgeEntryModule]
            makeSureViewControllersLoadTheirNavigationItems(viewControllers)
            
            knowledgeNavigationController.setViewControllers(viewControllers, animated: false)
        }
    }
    
    private func makeSureViewControllersLoadTheirNavigationItems(_ viewControllers: [UIViewController]) {
        viewControllers.forEach({ $0.loadViewIfNeeded() })
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
    
    func eventFeedbackCancelled() {
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
        
        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = true
        }
        
        tabController?.present(navigationController, animated: animate)
    }
    
    func messagesModuleDidRequestPresentation(for message: MessageIdentifier) {
        openMessage(message, revealStyle: .push)
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
        openDealer(identifier)
    }
    
    // MARK: KnowledgeGroupsListModuleDelegate
    
    func knowledgeListModuleDidSelectKnowledgeGroup(_ knowledgeGroup: KnowledgeGroupIdentifier) {
        let module = moduleRepository.makeKnowledgeGroupEntriesModule(knowledgeGroup, delegate: self)
        knowledgeListController?.navigationController?.pushViewController(module, animated: animate)
    }
    
    func knowledgeListModuleDidSelectKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier) {
        let knowledgeEntryModule = moduleRepository.makeKnowledgeDetailModule(knowledgeEntry, delegate: self)
        knowledgeListController?.navigationController?.pushViewController(knowledgeEntryModule, animated: animate)
    }
    
    // MARK: KnowledgeGroupEntriesModuleDelegate
    
    func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntryIdentifier) {
        let knowledgeEntryModule = moduleRepository.makeKnowledgeDetailModule(identifier, delegate: self)
        knowledgeListController?.navigationController?.pushViewController(knowledgeEntryModule, animated: animate)
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
    
    private func makeTabNavigationControllers() -> [UINavigationController] {
        return [makeNewsNavigationController(),
                makeScheduleNavigationController(),
                makeDealersNavigationController(),
                makeKnowledgeNavigationController(),
                makeMapsNavigationController(),
                makeCollectThemAllNavigationController(),
                makeAdditionalServicesNavigationController()]
    }
    
    private func makeNewsNavigationController() -> UINavigationController {
        let newsController = moduleRepository.makeNewsModule(newsDelegate ?? self)
        self.newsController = newsController
        
        return makeRootNavigationController(forModuleViewController: newsController)
    }
    
    private func makeScheduleNavigationController() -> UINavigationController {
        let scheduleViewController = moduleRepository.makeScheduleModule(self)
        self.scheduleViewController = scheduleViewController
        
        return makeRootNavigationController(forModuleViewController: scheduleViewController)
    }
    
    private func makeDealersNavigationController() -> UINavigationController {
        let dealersViewController = moduleRepository.makeDealersModule(self)
        self.dealersViewController = dealersViewController
        
        return makeRootNavigationController(forModuleViewController: dealersViewController)
    }
    
    private func makeKnowledgeNavigationController() -> UINavigationController {
        let knowledgeListController = moduleRepository.makeKnowledgeListModule(self)
        self.knowledgeListController = knowledgeListController
        
        return makeRootNavigationController(forModuleViewController: knowledgeListController)
    }
    
    private func makeMapsNavigationController() -> UINavigationController {
        let mapsModule = moduleRepository.makeMapsModule(self)
        self.mapsModule = mapsModule
        
        return makeRootNavigationController(forModuleViewController: mapsModule)
    }
    
    private func makeCollectThemAllNavigationController() -> UINavigationController {
        let collectThemAllModule = moduleRepository.makeCollectThemAllModule()
        return makeRootNavigationController(forModuleViewController: collectThemAllModule)
    }
    
    private func makeAdditionalServicesNavigationController() -> UINavigationController {
        let additionalServicesModule = moduleRepository.makeAdditionalServicesModule()
        return makeRootNavigationController(forModuleViewController: additionalServicesModule)
    }
    
    private func makeRootNavigationController(forModuleViewController viewController: UIViewController) -> UINavigationController {
        let navigationController = navigationControllerFactory.makeNavigationController()
        navigationController.setViewControllers([viewController], animated: animate)
        navigationController.tabBarItem = viewController.tabBarItem
        
        return navigationController
    }
    
    private func applyRestorationIdentifiers(_ moduleControllers: [UINavigationController]) {
        moduleControllers.forEach { (navigationController) in
            guard let identifier = navigationController.topViewController?.restorationIdentifier else { return }
            navigationController.restorationIdentifier = "NAV_" + identifier
        }
    }
    
    private enum RevealStyle {
        case push
        case replace
    }
    
    private func openMessage(_ message: MessageIdentifier, revealStyle: RevealStyle) {
        guard let newsController = newsController,
            let newsNavigationController = newsController.navigationController,
            let tabBarController = tabController,
            let index = tabBarController.viewControllers?.firstIndex(of: newsNavigationController) else { return }
        
        tabBarController.selectedIndex = index
        let messageViewController = moduleRepository.makeMessageDetailModule(message: message)
        
        switch revealStyle {
        case .push:
            newsNavigationController.pushViewController(messageViewController, animated: animate)
            
        case .replace:
            let messages = moduleRepository.makeMessagesModule(self)
            newsNavigationController.setViewControllers([newsController, messages, messageViewController], animated: animate)
        }
    }
    
}
