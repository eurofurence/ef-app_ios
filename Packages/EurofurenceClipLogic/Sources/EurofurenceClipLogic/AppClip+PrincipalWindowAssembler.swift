import ComponentBase
import ContentController
import DealersComponent
import DealersJourney
import EurofurenceModel
import EventsJourney
import RouterCore
import ScheduleComponent
import UIKit
import URLContent
import UserActivityRouteable

extension AppClip {
    
    struct PrincipalWindowScene: WindowScene {
        
        func resume(_ activity: NSUserActivity) {
            let content = EurofurenceUserActivityRouteable(userActivity: activity)
            routing.route(content)
        }
        
        func open(URLContexts: Set<UIOpenURLContext>) {
            guard let url = URLContexts.first?.url else { return }
            
            let content = EurofurenceURLRouteable(url)
            routing.route(content)
        }
        
        private let routing: EurofurenceClipRouting
        
        func route<Content>(_ content: Content) where Content: Routeable {
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
            
            var routes = AppClipRoutes(window: window, components: components).routes
            
            let scheduleFactoryAdapter = ScheduleFactoryAdapter(
                scheduleComponentFactory: components.scheduleComponentFactory,
                router: routes
            )
            
            let dealersFactoryAdapter = DealersFactoryAdapter(
                dealersComponentFactory: components.dealersComponentFactory,
                router: routes
            )
            
            let rootContainerViewController = RootContainerViewController()
            
            let clipContentScene = WireframeBasedClipContentScene(
                wireframe: rootContainerViewController,
                scheduleComponent: scheduleFactoryAdapter,
                dealersComponent: dealersFactoryAdapter
            )
            
            routes.install(ReplaceSceneWithScheduleRoute(scene: clipContentScene))
            routes.install(ReplaceSceneWithDealersRoute(scene: clipContentScene))
            
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
            
            let stateSensitiveRoutes = LoadedContentRouter(
                stateService: services.sessionState,
                destinationRoutes: routes
            )
            
            let clipRouting = EurofurenceClipRouting(router: stateSensitiveRoutes, clipScene: clipContentScene)
            self.routing = clipRouting
        }
        
        private struct ScheduleFactoryAdapter: ClipContentControllerFactory {
            
            var scheduleComponentFactory: ScheduleComponentFactory
            var router: Router
            
            func makeContentController() -> UIViewController {
                let scheduleViewController = scheduleComponentFactory.makeScheduleComponent(
                    ScheduleSubrouter(router: router)
                )
                
                let scheduleNavigationController = BrandedNavigationController(
                    rootViewController: scheduleViewController
                )
                
                let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
                let noContentNavigation = UINavigationController(rootViewController: noContentPlaceholder)
                let split = BrandedSplitViewController()
                split.viewControllers = [scheduleNavigationController, noContentNavigation]
                
                return split
            }
            
        }
        
        private struct DealersFactoryAdapter: ClipContentControllerFactory {
            
            var dealersComponentFactory: DealersComponentFactory
            var router: Router
            
            func makeContentController() -> UIViewController {
                let dealersViewController = dealersComponentFactory.makeDealersComponent(
                    ShowDealerFromDealers(router: router)
                )
                
                let dealersNavigationController = BrandedNavigationController(rootViewController: dealersViewController)
                let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
                let noContentNavigation = UINavigationController(rootViewController: noContentPlaceholder)
                let split = BrandedSplitViewController()
                split.viewControllers = [dealersNavigationController, noContentNavigation]
                
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
