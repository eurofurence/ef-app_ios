import ComponentBase
import EventDetailComponent
import EventsJourney
import RouterCore
import ScheduleComponent
import UIKit

struct EventsRoutes: RouteProvider {
    
    var globalRouter: Router
    var eventDetailComponentFactory: EventDetailComponentFactory
    var contentWireframe: ContentWireframe
    var window: UIWindow
    
    var routes: Routes {
        Routes {
            let popToScheduleRoot = MoveToTabByViewController<ScheduleViewController>(
                window: window,
                shouldPopToRoot: true
            )
            
            let showScheduleTabRoot = SwapToScheduleTabPresentation(tabNavigator: popToScheduleRoot)
            let tabSwapper = MoveToTabByViewController<ScheduleViewController>(window: window)
            let leaveFeedback = LeaveFeedbackFromEventNavigator(router: globalRouter)
            
            ScheduleRoute(presentation: showScheduleTabRoot)
            
            EventRoute(
                eventModuleFactory: eventDetailComponentFactory,
                eventDetailDelegate: leaveFeedback,
                contentWireframe: MoveToTabContentWireframe(
                    decoratedWireframe: contentWireframe,
                    tabSwapper: tabSwapper
                )
            )
            
            EmbeddedEventRoute(
                eventModuleFactory: eventDetailComponentFactory,
                eventDetailDelegate: leaveFeedback,
                contentWireframe: contentWireframe
            )
        }
    }
    
}
