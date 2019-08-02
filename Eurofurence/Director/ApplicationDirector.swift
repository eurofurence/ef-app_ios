import EurofurenceModel
import UIKit

class ApplicationDirector: RootModuleDelegate, TutorialModuleDelegate, PreloadModuleDelegate {
    
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

    private var newsController: UIViewController?
    private var scheduleViewController: UIViewController?
    private var knowledgeListController: UIViewController?
    private var dealersViewController: UIViewController?
    private var mapsModule: UIViewController?

    private var tabController: UITabBarController?
    
    private var tabBarDirector: TabBarDirector?
    
    init(animate: Bool,
         moduleRepository: ModuleRepository,
         linkLookupService: ContentLinksService,
         urlOpener: URLOpener,
         orderingPolicy: ModuleOrderingPolicy,
         windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         tabModuleProviding: TabModuleProviding) {
        self.animate = animate
        self.moduleRepository = moduleRepository
        self.navigationControllerFactory = navigationControllerFactory
        self.tabModuleProviding = tabModuleProviding
        self.linkLookupService = linkLookupService
        self.urlOpener = urlOpener
        self.orderingPolicy = orderingPolicy
        self.windowWireframe = windowWireframe

        moduleRepository.makeRootModule(self)
    }

    // MARK: Public
    
    func openAnnouncement(_ announcement: AnnouncementIdentifier) {
        tabBarDirector?.openAnnouncement(announcement)
    }
    
    func openEvent(_ event: EventIdentifier) {
        tabBarDirector?.openEvent(event)
    }
    
    func openDealer(_ dealer: DealerIdentifier) {
        tabBarDirector?.openDealer(dealer)
    }
    
    func openMessage(_ message: MessageIdentifier) {
        tabBarDirector?.openMessage(message)
    }
    
    func openKnowledgeGroups() {
        tabBarDirector?.openKnowledgeGroups()
    }
    
    func showInvalidatedAnnouncementAlert() {
        tabBarDirector?.showInvalidatedAnnouncementAlert()
    }
    
    func openKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier, parentGroup: KnowledgeGroupIdentifier) {
        tabBarDirector?.openKnowledgeEntry(knowledgeEntry, parentGroup: parentGroup)
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
        tabBarDirector = TabBarDirector(animate: animate,
                                        moduleRepository: moduleRepository,
                                        linkLookupService: linkLookupService,
                                        urlOpener: urlOpener,
                                        orderingPolicy: orderingPolicy,
                                        windowWireframe: windowWireframe,
                                        navigationControllerFactory: navigationControllerFactory,
                                        tabModuleProviding: tabModuleProviding)
        
    }

}
