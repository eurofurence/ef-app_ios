import EurofurenceModel
import UIKit.UIViewController

class DirectorBuilder {

    private var animate: Bool
    private var linkLookupService: ContentLinksService
    private let moduleRepository: ModuleRepository
    private var orderingPolicy: ModuleOrderingPolicy
    
    private var windowWireframe: WindowWireframe
    private var navigationControllerFactory: NavigationControllerFactory
    private var tabModuleProviding: TabModuleProviding
    private var urlOpener: URLOpener

    init(moduleRepository: ModuleRepository, linkLookupService: ContentLinksService) {
        animate = true
        self.moduleRepository = moduleRepository
        orderingPolicy = RestorationIdentifierOrderingPolicy()
        windowWireframe = AppWindowWireframe.shared
        navigationControllerFactory = PlatformNavigationControllerFactory()
        tabModuleProviding = PlatformTabModuleFactory()

        self.linkLookupService = linkLookupService
        urlOpener = AppURLOpener()
    }

    @discardableResult
    func withAnimations(_ animate: Bool) -> DirectorBuilder {
        self.animate = animate
        return self
    }

    @discardableResult
    func with(_ orderingPolicy: ModuleOrderingPolicy) -> DirectorBuilder {
        self.orderingPolicy = orderingPolicy
        return self
    }

    @discardableResult
    func with(_ windowWireframe: WindowWireframe) -> DirectorBuilder {
        self.windowWireframe = windowWireframe
        return self
    }

    @discardableResult
    func with(_ navigationControllerFactory: NavigationControllerFactory) -> DirectorBuilder {
        self.navigationControllerFactory = navigationControllerFactory
        return self
    }

    @discardableResult
    func with(_ tabModuleProviding: TabModuleProviding) -> DirectorBuilder {
        self.tabModuleProviding = tabModuleProviding
        return self
    }

    @discardableResult
    func with(_ urlOpener: URLOpener) -> DirectorBuilder {
        self.urlOpener = urlOpener
        return self
    }
    
    private var newsDelegate: NewsModuleDelegate?
    
    @discardableResult
    func with(_ newsDelegate: NewsModuleDelegate) -> DirectorBuilder {
        self.newsDelegate = newsDelegate
        return self
    }
    
    private var scheduleDelegate: ScheduleModuleDelegate?
    
    @discardableResult
    func with(_ scheduleDelegate: ScheduleModuleDelegate) -> Self {
        self.scheduleDelegate = scheduleDelegate
        return self
    }
    
    private var dealersDelegate: DealersModuleDelegate?
    
    @discardableResult
    func with(_ dealersDelegate: DealersModuleDelegate) -> Self {
        self.dealersDelegate = dealersDelegate
        return self
    }
    
    private var knowledgeDelegate: KnowledgeGroupsListModuleDelegate?
    
    @discardableResult
    func with(_ knowledgeDelegate: KnowledgeGroupsListModuleDelegate) -> Self {
        self.knowledgeDelegate = knowledgeDelegate
        return self
    }
    
    private var mapsDelegate: MapsModuleDelegate?
    
    @discardableResult
    func with(_ mapsDelegate: MapsModuleDelegate) -> Self {
        self.mapsDelegate = mapsDelegate
        return self
    }

    func build() -> ApplicationDirector {
        return ApplicationDirector(animate: animate,
                                   moduleRepository: moduleRepository,
                                   linkLookupService: linkLookupService,
                                   urlOpener: urlOpener,
                                   orderingPolicy: orderingPolicy,
                                   windowWireframe: windowWireframe,
                                   navigationControllerFactory: navigationControllerFactory,
                                   tabModuleProviding: tabModuleProviding,
                                   newsDelegate: newsDelegate,
                                   scheduleDelegate: scheduleDelegate,
                                   dealersDelegate: dealersDelegate,
                                   knowledgeDelegate: knowledgeDelegate,
                                   mapsDelegate: mapsDelegate)
    }

}
