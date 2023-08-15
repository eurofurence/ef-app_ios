import ComponentBase
import ContentController
import DealersJourney
import EurofurenceModel
import EventsJourney
import KnowledgeJourney
import os
import RouterCore
import UIKit

struct PrincipalWindowAssembler {
    
    private static let log = OSLog(subsystem: "org.eurofurence.EurofurenceApplication", category: "Principal Window")
    
    private var router: Router
    private let contentWireframe: WindowContentWireframe
    private let modalWireframe: WindowModalWireframe
    
    func route<T>(_ content: T) where T: Routeable {
        do {
            try router.route(content)
        } catch {
            let errorDescription = String(describing: error)
            
#if DEBUG
            fatalError(errorDescription)
#else
            os_log("%{public}s", log: Self.log, type: .error, errorDescription)
#endif
        }
    }
    
    init(
        dependencies: Application.Dependencies,
        window: UIWindow,
        services: Services,
        repositories: Repositories,
        urlOpener: URLOpener
    ) {
        contentWireframe = WindowContentWireframe(window: window)
        modalWireframe = WindowModalWireframe(window: window)
        
        let componentRegistry = ComponentRegistry(
            dependencies: dependencies,
            services: services,
            repositories: repositories,
            window: window
        )
        
        let routes = PrincipalWindowRoutes(
            contentWireframe: contentWireframe,
            modalWireframe: modalWireframe,
            componentRegistry: componentRegistry,
            authenticationService: services.authentication,
            linksService: services.contentLinks,
            urlOpener: urlOpener,
            window: window
        ).routes
        
        self.router = routes
        
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
        
        self.router = LoadedContentRouter(stateService: services.sessionState, destinationRoutes: routes)
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
        
// TODO: Reenable widget once support for new IDP has been implemented
//        let collectThemAllContentControllerFactory = CollectThemAllContentControllerFactory(
//            collectThemAllComponentFactory: componentRegistry.collectThemAllComponentFactory
//        )
//
//        let additionalServicesContentControllerFactory = AdditionalServicesContentControllerFactory(
//            additionalServicesComponentFactory: componentRegistry.additionalServicesComponentFactory
//        )
//
//        let moreContentControllerFactory = MoreContentControllerFactory(supplementaryContentControllerFactories: [
//            SupplementaryContentController(
//                contentControllerFactory: mapsContentControllerFactory,
//                presentationHandler: contentWireframe.presentPrimaryContentController(_:)
//            ),
//            SupplementaryContentController(
//                contentControllerFactory: collectThemAllContentControllerFactory,
//                presentationHandler: contentWireframe.replaceDetailContentController(_:)
//            ),
//            SupplementaryContentController(
//                contentControllerFactory: additionalServicesContentControllerFactory,
//                presentationHandler: contentWireframe.replaceDetailContentController(_:)
//            )
//        ])
        
        return [
            newsContentControllerFactory,
            scheduleContentControllerFactory,
            dealersContentControllerFactory,
            knowledgeContentControllerFactory,
            mapsContentControllerFactory
        ]
    }
    
}
