import ComponentBase
import DealerComponent
import EventDetailComponent
import EventsJourney
import RouterCore
import UIKit

struct AppClipRoutes: RouteProvider {
    
    var window: UIWindow
    var components: AppClip.Components
    
    var routes: Routes {
        Routes { (router) in
            let contentWireframe = WindowContentWireframe(window: window)
            let leaveFeedback = LeaveFeedbackFromEventNavigator(router: router)
            
            EventRoute(
                eventModuleFactory: components.eventDetailComponentFactory,
                eventDetailDelegate: leaveFeedback,
                contentWireframe: contentWireframe
            )
            
            DealerRoute(
                dealerModuleFactory: components.dealerDetailModuleProviding,
                contentWireframe: contentWireframe
            )
        }
    }
    
}
