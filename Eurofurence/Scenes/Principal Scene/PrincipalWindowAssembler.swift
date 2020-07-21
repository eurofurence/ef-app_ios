import EurofurenceModel
import UIKit

struct PrincipalWindowAssembler {
    
    private let router: ContentRouter
    private let contentWireframe: WindowContentWireframe
    private let modalWireframe: WindowModalWireframe
    
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
        
        contentWireframe = WindowContentWireframe(window: window)
        modalWireframe = WindowModalWireframe(window: window)
        
        let moduleRepository = ComponentRegistry(
            services: services,
            repositories: repositories,
            window: window
        )
        
        configureGlobalRoutes(
            router: router,
            moduleRepository: moduleRepository,
            services: services,
            urlOpener: urlOpener,
            window: window
        )
        
        configureComponents(moduleRepository: moduleRepository, window: window, services: services)
    }
    
    private func configureGlobalRoutes(
        router: MutableContentRouter,
        moduleRepository: ComponentRegistry,
        services: Services,
        urlOpener: URLOpener,
        window: UIWindow
    ) {
        let routeAuthenticationHandler = AuthenticateOnDemandRouteAuthenticationHandler(
            service: services.authentication,
            router: router
        )
        
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
    }
    
    private func configureComponents(moduleRepository: ComponentRegistry, window: UIWindow, services: Services) {
        let applicationModuleFactories = makePrincipalWindowComponents(
            moduleRepository: moduleRepository,
            window: window,
            services: services
        )
        
        let principalWindowScene = ModuleSwappingPrincipalWindowScene(
            windowWireframe: AppWindowWireframe(window: window),
            tutorialModule: moduleRepository.tutorialComponentFactory,
            preloadModule: moduleRepository.preloadComponentFactory,
            principalContentModule: PrincipalContentAggregator(applicationModuleFactories: applicationModuleFactories)
        )
        
        _ = PrincipalWindowSceneController(sessionState: services.sessionState, scene: principalWindowScene)
    }
    
    private func makePrincipalWindowComponents(
        moduleRepository: ComponentRegistry,
        window: UIWindow,
        services: Services
    ) -> [ApplicationModuleFactory] {
        let newsContentControllerFactory = NewsContentControllerFactory(
            newsComponentFactory: moduleRepository.newsComponentFactory,
            newsComponentDelegate: NewsSubrouter(router: router)
        )
        
        let scheduleContentControllerFactory = ScheduleContentControllerFactory(
            scheduleComponentFactory: moduleRepository.scheduleComponentFactory,
            scheduleComponentDelegate: ShowEventFromSchedule(router: router)
        )
        
        let dealersContentControllerFactory = DealersContentControllerFactory(
            dealersComponentFactory: moduleRepository.dealersComponentFactory,
            dealersComponentDelegate: ShowDealerFromDealers(router: router)
        )
        
        let knowledgeContentControllerFactory = KnowledgeContentControllerFactory(
            knowledgeModuleProviding: moduleRepository.knowledgeListComponentFactory,
            knowledgeModuleDelegate: ShowKnowledgeContentFromListing(router: router)
        )
        
        let mapsContentControllerFactory = MapsContentControllerFactory(
            mapsComponentFactory: moduleRepository.mapsComponentFactory,
            mapsComponentDelegate: ShowMapFromMaps(router: router)
        )
        
        let collectThemAllContentControllerFactory = CollectThemAllContentControllerFactory(
            collectThemAllComponentFactory: moduleRepository.collectThemAllComponentFactory
        )
        
        let additionalServicesContentControllerFactory = AdditionalServicesContentControllerFactory(
            additionalServicesComponentFactory: moduleRepository.additionalServicesComponentFactory
        )
        
        let moreContentControllerFactory = MoreContentControllerFactory(supplementaryContentControllerFactories: [
            SupplementaryContentController(
                contentControllerFactory: mapsContentControllerFactory,
                presentationHandler: contentWireframe.presentMasterContentController(_:)
            ),
            SupplementaryContentController(
                contentControllerFactory: collectThemAllContentControllerFactory,
                presentationHandler: contentWireframe.presentDetailContentController(_:)
            ),
            SupplementaryContentController(
                contentControllerFactory: additionalServicesContentControllerFactory,
                presentationHandler: contentWireframe.presentDetailContentController(_:)
            )
        ])
        
        return [
            newsContentControllerFactory,
            scheduleContentControllerFactory,
            dealersContentControllerFactory,
            knowledgeContentControllerFactory,
            moreContentControllerFactory
        ]
    }
    
}
