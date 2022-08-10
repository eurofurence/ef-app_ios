import ComponentBase
import DealerComponent
import DealersComponent
import DealersJourney
import EurofurenceModel
import EventDetailComponent
import EventFeedbackComponent
import EventsJourney
import KnowledgeDetailComponent
import KnowledgeGroupsComponent
import KnowledgeJourney
import RouterCore
import ScheduleComponent
import UIKit

struct PrincipalWindowRoutes: RouteProvider {
    
    var contentWireframe: ContentWireframe
    var modalWireframe: ModalWireframe
    var componentRegistry: ComponentRegistry
    var authenticationService: AuthenticationService
    var linksService: ContentLinksService
    var urlOpener: URLOpener
    var window: UIWindow
    
    var routes: Routes {
        Routes { (router) in
            let routeAuthenticationHandler = AuthenticateOnDemandRouteAuthenticationHandler(
                service: authenticationService,
                router: router
            )
            
            NewsRoutes(
                components: componentRegistry,
                routeAuthenticationHandler: routeAuthenticationHandler,
                contentWireframe: contentWireframe,
                modalWireframe: modalWireframe,
                window: window
            )
            
            DealersRouters(
                dealerDetailModuleProviding: componentRegistry.dealerDetailModuleProviding,
                contentWireframe: contentWireframe,
                window: window
            )
            
            EventsRoutes(
                globalRouter: router,
                eventDetailComponentFactory: componentRegistry.eventDetailComponentFactory,
                contentWireframe: contentWireframe,
                window: window
            )
            
            EventFeedbackRoute(
                eventFeedbackFactory: FormSheetEventFeedbackComponentFactory(
                    eventFeedbackComponentFactory: componentRegistry.eventFeedbackComponentFactory
                ),
                modalWireframe: modalWireframe
            )
            
            KnowledgeRoutes(
                components: componentRegistry,
                contentWireframe: contentWireframe,
                modalWireframe: modalWireframe,
                linksService: linksService,
                window: window
            )
            
            MapRoute(
                mapModuleProviding: componentRegistry.mapDetailComponentFactory,
                contentWireframe: contentWireframe,
                delegate: ShowDealerFromMap(router: router)
            )
            
            WebPageRoute(
                webComponentFactory: componentRegistry.webComponentFactory,
                modalWireframe: modalWireframe
            )
            
            ExternalApplicationRoute(urlOpener: urlOpener)
        }
    }
    
}
