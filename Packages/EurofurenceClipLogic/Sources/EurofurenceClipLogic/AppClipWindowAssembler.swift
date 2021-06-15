import ComponentBase
import ContentController
import DealersComponent
import DealersJourney
import EurofurenceModel
import EventsJourney
import PreloadComponent
import ScheduleComponent
import TutorialComponent
import UIKit

struct AppClipWindowAssembler {
    
    private let routing: EurofurenceClipRouting
    
    func route<Content>(_ content: Content) where Content: ContentRepresentation {
        routing.route(content)
    }
    
    init(window: UIWindow, repositories: Repositories, services: Services) {
        let alertRouter = WindowAlertRouter(window: window)
        let tutorialComponent = TutorialModuleBuilder(alertRouter: alertRouter).build()
        
        let preloadInteractor = ApplicationPreloadInteractor(refreshService: services.refresh)
        let preloadComponent = PreloadComponentBuilder(
            preloadInteractor: preloadInteractor,
            alertRouter: alertRouter
        ).build()
        
        let router = MutableContentRouter()
        let shareService = ActivityShareService(window: window)
        
        let scheduleViewModelFactory = DefaultScheduleViewModelFactory(
            eventsService: services.events,
            hoursDateFormatter: FoundationHoursDateFormatter.shared,
            shortFormDateFormatter: FoundationShortFormDateFormatter.shared,
            shortFormDayAndTimeFormatter: FoundationShortFormDayAndTimeFormatter.shared,
            refreshService: services.refresh,
            shareService: shareService
        )
        
        let scheduleComponentFactory = ScheduleModuleBuilder(
            scheduleViewModelFactory: scheduleViewModelFactory
        ).build()
        
        let scheduleFactoryAdapter = ScheduleFactoryAdapter(
            scheduleComponentFactory: scheduleComponentFactory,
            router: router
        )
        
        let dealersViewModelFactory = DefaultDealersViewModelFactory(
            dealersService: services.dealers,
            refreshService: services.refresh
        )
        
        let dealersComponentFactory = DealersComponentBuilder(
            dealersViewModelFactory: dealersViewModelFactory
        ).build()
        
        let dealersFactoryAdapter = DealersFactoryAdapter(
            dealersComponentFactory: dealersComponentFactory,
            router: router
        )
        
        let rootContainerViewController = RootContainerViewController()
        let clipContentScene = WireframeBasedClipContentScene(
            wireframe: rootContainerViewController,
            scheduleComponent: scheduleFactoryAdapter,
            dealersComponent: dealersFactoryAdapter
        )
        
        let clipRouting = EurofurenceClipRouting(router: router, clipScene: clipContentScene)
        self.routing = clipRouting
        
        let appClipModule = ContainerModuleWrapper(containerViewController: rootContainerViewController)
        
        let scene = ComponentBasedBootstrappingScene(
            windowWireframe: AppWindowWireframe(window: window),
            tutorialModule: tutorialComponent,
            preloadModule: preloadComponent,
            principalContentModule: appClipModule
        )
        
        _ = ContentSceneController(
            sessionState: services.sessionState,
            scene: scene
        )
    }
    
    private struct ScheduleFactoryAdapter: ClipContentControllerFactory {
        
        var scheduleComponentFactory: ScheduleComponentFactory
        var router: ContentRouter
        
        func makeContentController() -> UIViewController {
            scheduleComponentFactory.makeScheduleComponent(ScheduleSubrouter(router: router))
        }
        
    }
    
    private struct DealersFactoryAdapter: ClipContentControllerFactory {
        
        var dealersComponentFactory: DealersComponentFactory
        var router: ContentRouter
        
        func makeContentController() -> UIViewController {
            dealersComponentFactory.makeDealersComponent(ShowDealerFromDealers(router: router))
        }
        
    }
    
    private struct ContainerModuleWrapper: PrincipalContentModuleFactory {
        
        var containerViewController: UIViewController
        
        func makePrincipalContentModule() -> UIViewController {
            containerViewController
        }
        
    }
    
}
