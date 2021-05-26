import ComponentBase
import ContentController
import DealersJourney
import EurofurenceModel
import EventsJourney
import KnowledgeJourney
import UIKit

struct PrincipalWindowAssembler {
    
    private let router: ContentRouter
    private let contentWireframe: WindowContentWireframe
    private let modalWireframe: WindowModalWireframe
    
    func route<T>(_ content: T) where T: ContentRepresentation {
        try? router.route(content)
    }
    
    init(
        dependencies: Application.Dependencies,
        window: UIWindow,
        services: Services,
        repositories: Repositories,
        urlOpener: URLOpener
    ) {
        let router = MutableContentRouter()
        self.router = router
        
        contentWireframe = WindowContentWireframe(window: window)
        modalWireframe = WindowModalWireframe(window: window)
        
        let componentRegistry = ComponentRegistry(
            dependencies: dependencies,
            services: services,
            repositories: repositories,
            window: window
        )
        
        configureGlobalRoutes(
            router: router,
            componentRegistry: componentRegistry,
            services: services,
            urlOpener: urlOpener,
            window: window
        )
        
        configureComponents(componentRegistry: componentRegistry, window: window, services: services)
    }
    
    private func configureGlobalRoutes(
        router: MutableContentRouter,
        componentRegistry: ComponentRegistry,
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
            componentRegistry: componentRegistry,
            routeAuthenticationHandler: routeAuthenticationHandler,
            linksService: services.contentLinks,
            urlOpener: urlOpener,
            window: window
        ).configureRoutes()
    }
    
    private func configureComponents(componentRegistry: ComponentRegistry, window: UIWindow, services: Services) {
        let applicationModuleFactories = makePrincipalWindowComponents(
            componentRegistry: componentRegistry,
            window: window,
            services: services
        )
        
        let principalWindowScene = ComponentBasedBootstrappingScene(
            windowWireframe: AppWindowWireframe(window: window),
            tutorialModule: componentRegistry.tutorialComponentFactory,
            preloadModule: componentRegistry.preloadComponentFactory,
            principalContentModule: ApplicationPrincipalModuleFactory(
                applicationModuleFactories: applicationModuleFactories
            )
        )
        
        _ = ContentSceneController(sessionState: services.sessionState, scene: principalWindowScene)
    }
    
    private func makePrincipalWindowComponents(
        componentRegistry: ComponentRegistry,
        window: UIWindow,
        services: Services
    ) -> [ApplicationModuleFactory] {
        let newsContentControllerFactory = NewsContentControllerFactory(
            newsComponentFactory: componentRegistry.newsComponentFactory,
            newsComponentDelegate: NewsSubrouter(router: router)
        )
        
        let scheduleContentControllerFactory = ScheduleContentControllerFactory(
            scheduleComponentFactory: componentRegistry.scheduleComponentFactory,
            scheduleComponentDelegate: ScheduleSubrouter(router: router)
        )
        
        let dealersContentControllerFactory = DealersContentControllerFactory(
            dealersComponentFactory: componentRegistry.dealersComponentFactory,
            dealersComponentDelegate: ShowDealerFromDealers(router: router)
        )
        
        let knowledgeContentControllerFactory = KnowledgeContentControllerFactory(
            knowledgeModuleProviding: componentRegistry.knowledgeListComponentFactory,
            knowledgeModuleDelegate: ShowKnowledgeContentFromListing(router: router)
        )
        
        let mapsContentControllerFactory = MapsContentControllerFactory(
            mapsComponentFactory: componentRegistry.mapsComponentFactory,
            mapsComponentDelegate: ShowMapFromMaps(router: router)
        )
        
        let collectThemAllContentControllerFactory = CollectThemAllContentControllerFactory(
            collectThemAllComponentFactory: componentRegistry.collectThemAllComponentFactory
        )
        
        let additionalServicesContentControllerFactory = AdditionalServicesContentControllerFactory(
            additionalServicesComponentFactory: componentRegistry.additionalServicesComponentFactory
        )
        
        let moreContentControllerFactory = MoreContentControllerFactory(supplementaryContentControllerFactories: [
            SupplementaryContentController(
                contentControllerFactory: mapsContentControllerFactory,
                presentationHandler: contentWireframe.presentPrimaryContentController(_:)
            ),
            SupplementaryContentController(
                contentControllerFactory: collectThemAllContentControllerFactory,
                presentationHandler: contentWireframe.replaceDetailContentController(_:)
            ),
            SupplementaryContentController(
                contentControllerFactory: additionalServicesContentControllerFactory,
                presentationHandler: contentWireframe.replaceDetailContentController(_:)
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
