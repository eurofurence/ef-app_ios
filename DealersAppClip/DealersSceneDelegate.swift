import ComponentBase
import DealerComponent
import DealersComponent
import EurofurenceApplicationSession
import EurofurenceModel
import UIKit

class DealersSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = BrandedSplitViewController()
        window.rootViewController = rootViewController
        
        let session = EurofurenceSessionBuilder.buildingForEurofurenceApplication().build()
        let services = session.services
        
        struct DoNotDonateDealerInteraction: DealerInteractionRecorder {
            
            func makeInteraction(for dealer: DealerIdentifier) -> Interaction? {
                nil
            }
            
        }
        
        let dealersViewModelFactory = DefaultDealersViewModelFactory(
            dealersService: services.dealers,
            refreshService: services.refresh
        )
        
        let dealersComponentFactory = DealersComponentBuilder(
            dealersViewModelFactory: dealersViewModelFactory
        ).build()
        
        let shareService = ActivityShareService(window: window)
        let dealerDetailViewModelFactory = DefaultDealerDetailViewModelFactory(
            dealersService: services.dealers,
            shareService: shareService
        )

        let dealerDetailModuleProviding = DealerDetailComponentBuilder(
            dealerDetailViewModelFactory: dealerDetailViewModelFactory,
            dealerInteractionRecorder: DoNotDonateDealerInteraction()
        ).build()
        
        let showDealerInDetailPane = ShowDealerInDetailPane(
            splitViewController: rootViewController,
            dealerDetailModuleProviding: dealerDetailModuleProviding
        )
        
        let dealersModule = dealersComponentFactory.makeDealersComponent(showDealerInDetailPane)
        let dealersNavigationController = BrandedNavigationController(rootViewController: dealersModule)
        let placeholderViewController = NoContentPlaceholderViewController.fromStoryboard()
        let placeholderNavigation = BrandedNavigationController(rootViewController: placeholderViewController)
        rootViewController.viewControllers = [dealersNavigationController, placeholderNavigation]
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    struct ShowDealerInDetailPane: DealersComponentDelegate {
        
        var splitViewController: UISplitViewController
        var dealerDetailModuleProviding: DealerDetailComponentFactory
        
        func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
            let dealerDetailComponent = dealerDetailModuleProviding.makeDealerDetailComponent(for: identifier)
            splitViewController.showDetailViewController(
                dealerDetailComponent,
                sender: DetailPresentationContext.replace
            )
        }
        
    }

}
