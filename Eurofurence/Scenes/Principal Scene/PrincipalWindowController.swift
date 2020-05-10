import EurofurenceModel
import UIKit

struct PrincipalWindowController {
    
    private let router: ContentRouter
    
    func route<T>(_ content: T) where T: ContentRepresentation {
        try? router.route(content)
    }
    
    init(
        window: UIWindow,
        services: Services,
        repositories: Repositories,
        urlOpener: URLOpener
    ) {
        let router = MutableContentRouter()
        self.router = router
        
        let moduleRepository = ApplicationModuleRepository(
            services: services,
            repositories: repositories,
            window: window
        )
        
        let newsSubrouter = NewsSubrouter(router: router)
        let scheduleSubrouter = ShowEventFromSchedule(router: router)
        let dealerSubrouter = ShowDealerFromDealers(router: router)
        let knowledgeSubrouter = ShowKnowledgeContentFromListing(router: router)
        let mapSubrouter = ShowMapFromMaps(router: router)
        
        let routeAuthenticationHandler = AuthenticateOnDemandRouteAuthenticationHandler(
            service: services.authentication,
            router: router
        )
        
        let contentWireframe = WindowContentWireframe(window: window)
        let modalWireframe = WindowModalWireframe(window: window)
        
        RouterConfigurator(
            router: router,
            contentWireframe: contentWireframe,
            modalWireframe: modalWireframe,
            moduleRepository: moduleRepository,
            routeAuthenticationHandler: routeAuthenticationHandler,
            linksService: services.contentLinks,
            urlOpener: urlOpener,
            window: window
        ).configureRoutes()
        
        let newsContentControllerFactory = NewsContentControllerFactory(
            newsComponentFactory: moduleRepository.newsComponentFactory,
            newsComponentDelegate: newsSubrouter
        )
        
        let scheduleContentControllerFactory = ScheduleContentControllerFactory(
            scheduleComponentFactory: moduleRepository.scheduleComponentFactory,
            scheduleComponentDelegate: scheduleSubrouter
        )
        
        let dealersContentControllerFactory = DealersContentControllerFactory(
            dealersComponentFactory: moduleRepository.dealersComponentFactory,
            dealersComponentDelegate: dealerSubrouter
        )
        
        let knowledgeContentControllerFactory = KnowledgeContentControllerFactory(
            knowledgeModuleProviding: moduleRepository.knowledgeListModuleProviding,
            knowledgeModuleDelegate: knowledgeSubrouter
        )
        
        let mapsContentControllerFactory = MapsContentControllerFactory(
            mapsComponentFactory: moduleRepository.mapsComponentFactory,
            mapsComponentDelegate: mapSubrouter
        )
        
        let collectThemAllContentControllerFactory = CollectThemAllContentControllerFactory(
            collectThemAllComponentFactory: moduleRepository.collectThemAllComponentFactory
        )
        
        let additionalServicesContentControllerFactory = AdditionalServicesContentControllerFactory(
            additionalServicesComponentFactory: moduleRepository.additionalServicesComponentFactory
        )
        
        let moreContentControllerFactory = MoreContentControllerFactory(supplementaryContentControllerFactories: [
            mapsContentControllerFactory,
            collectThemAllContentControllerFactory,
            additionalServicesContentControllerFactory
        ])
        
        let applicationModuleFactories: [ApplicationModuleFactory] = [
            newsContentControllerFactory,
            scheduleContentControllerFactory,
            dealersContentControllerFactory,
            knowledgeContentControllerFactory,
            moreContentControllerFactory
        ]
        
        let principalWindowScene = ModuleSwappingPrincipalWindowScene(
            windowWireframe: AppWindowWireframe(window: window),
            tutorialModule: moduleRepository.tutorialModuleProviding,
            preloadModule: moduleRepository.preloadComponentFactory,
            principalContentModule: PrincipalContentAggregator(applicationModuleFactories: applicationModuleFactories)
        )
        
        _ = PrincipalWindowSceneController(sessionState: services.sessionState, scene: principalWindowScene)
    }
    
}
