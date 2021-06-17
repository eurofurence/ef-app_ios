import ComponentBase
import ContentController
import DealersComponent
import DealersJourney
import EurofurenceModel
import EventsJourney
import ScheduleComponent
import UIKit
import URLContent

extension AppClip {
    
    struct PrincipalWindowScene: WindowScene {
        
        func resume(_ activity: NSUserActivity) {
            let activityDescription = SystemActivityDescription(userActivity: activity)
            let content = UserActivityContentRepresentation(activity: activityDescription)
            routing.route(content)
        }
        
        @available(iOS 13.0, *)
        func open(URLContexts: Set<UIOpenURLContext>) {
            let activityDescription = URLContextActivityDescription(URLContexts: URLContexts)
            let content = UserActivityContentRepresentation(activity: activityDescription)
            routing.route(content)
        }
        
        private let routing: EurofurenceClipRouting
        
        func route<Content>(_ content: Content) where Content: ContentRepresentation {
            routing.route(content)
        }
        
        init(
            window: UIWindow,
            dependencies: AppClip.Dependencies,
            repositories: Repositories,
            services: Services
        ) {
            let components = Components(
                window: window,
                dependencies: dependencies,
                repositories: repositories,
                services: services
            )
            
            let router = MutableContentRouter()
            RouterConfigurator(window: window, components: components).configure(router)
            
            let rootContainerViewController = RootContainerViewController()
            
            let scheduleFactoryAdapter = ScheduleFactoryAdapter(
                scheduleComponentFactory: components.scheduleComponentFactory,
                router: router
            )
            
            let dealersFactoryAdapter = DealersFactoryAdapter(
                dealersComponentFactory: components.dealersComponentFactory,
                router: router
            )
            
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
                tutorialModule: components.tutorialComponent,
                preloadModule: components.preloadComponent,
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
                let schedule = scheduleComponentFactory.makeScheduleComponent(ScheduleSubrouter(router: router))
                let primary = BrandedNavigationController(rootViewController: schedule)
                let secondary = NoContentPlaceholderViewController.fromStoryboard()
                let split = BrandedSplitViewController()
                split.viewControllers = [primary, secondary]
                
                return split
            }
            
        }
        
        private struct DealersFactoryAdapter: ClipContentControllerFactory {
            
            var dealersComponentFactory: DealersComponentFactory
            var router: ContentRouter
            
            func makeContentController() -> UIViewController {
                let dealers = dealersComponentFactory.makeDealersComponent(ShowDealerFromDealers(router: router))
                let primary = BrandedNavigationController(rootViewController: dealers)
                let secondary = NoContentPlaceholderViewController.fromStoryboard()
                let split = BrandedSplitViewController()
                split.viewControllers = [primary, secondary]
                
                return split
            }
            
        }
        
        private struct ContainerModuleWrapper: PrincipalContentModuleFactory {
            
            var containerViewController: UIViewController
            
            func makePrincipalContentModule() -> UIViewController {
                containerViewController
            }
            
        }
        
    }
    
}
