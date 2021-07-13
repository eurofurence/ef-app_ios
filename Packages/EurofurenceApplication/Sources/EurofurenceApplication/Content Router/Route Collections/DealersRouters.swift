import ComponentBase
import DealerComponent
import DealersComponent
import DealersJourney
import RouterCore
import UIKit

struct DealersRouters: RouteProvider {
    
    var dealerDetailModuleProviding: DealerDetailComponentFactory
    var contentWireframe: ContentWireframe
    var window: UIWindow
    
    var routes: Routes {
        Routes {
            let tabSwapper = MoveToTabByViewController<DealersViewController>(window: window)
            let poppingTabSwapper = MoveToTabByViewController<DealersViewController>(
                window: window,
                shouldPopToRoot: true
            )
            
            let tabPresentation = SwapToDealersTabPresentation(tabNavigator: poppingTabSwapper)
            
            DealersRoute(presentation: tabPresentation)
            
            DealerRoute(
                dealerModuleFactory: dealerDetailModuleProviding,
                contentWireframe: MoveToTabContentWireframe(
                    decoratedWireframe: contentWireframe,
                    tabSwapper: tabSwapper
                )
            )
            
            EmbeddedDealerRoute(
                dealerModuleFactory: dealerDetailModuleProviding,
                contentWireframe: contentWireframe
            )
        }
    }
    
}
