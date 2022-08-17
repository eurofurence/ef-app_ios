import ComponentBase
import RouterCore
import UIKit

struct NewsRoutes: RouteProvider {
    
    var components: ComponentRegistry
    var routeAuthenticationHandler: RouteAuthenticationHandler
    var contentWireframe: ContentWireframe
    var modalWireframe: ModalWireframe
    var window: UIWindow
    
    var routes: Routes {
        Routes { (router) in
            AnnouncementsRoute(
                announcementsComponentFactory: components.announcementsModuleFactory,
                contentWireframe: contentWireframe,
                delegate: NavigateFromAnnouncementsToAnnouncement(router: router)
            )
            
            AnnouncementRoute(
                announcementModuleFactory: components.announcementDetailComponentFactory,
                contentWireframe: MoveToTabContentWireframe(
                    decoratedWireframe: contentWireframe,
                    tabSwapper: MoveToTabByViewController<CompositionalNewsViewController>(window: window)
                )
            )
            
            NewsRoute(newsPresentation: ResetNewsAfterLogout(window: window))
            
            let tabSwapper = MoveToTabByViewController<CompositionalNewsViewController>(window: window)
            
            let messageContentRoute = MessageRoute(
                messageModuleFactory: components.messageDetailComponentFactory,
                contentWireframe: MoveToTabContentWireframe(
                    decoratedWireframe: contentWireframe,
                    tabSwapper: tabSwapper
                )
            )
            
            AuthenticatedRoute(
                route: messageContentRoute,
                routeAuthenticationHandler: routeAuthenticationHandler
            )
            
            let messagesRoute = MessagesRoute(
                messagesComponentFactory: components.messagesComponentFactory,
                contentWireframe: contentWireframe,
                delegate: NavigateFromMessagesToMessage(
                    router: router,
                    modalWireframe: modalWireframe
                )
            )
            
            AuthenticatedRoute(
                route: messagesRoute,
                routeAuthenticationHandler: routeAuthenticationHandler
            )
            
            let formSheetWrapper = FormSheetLoginComponentFactory(
                loginComponentFactory: components.loginComponentFactory
            )
            
            LoginRoute(loginModuleFactory: formSheetWrapper, modalWireframe: modalWireframe)
            
            SettingsRoute(modalWireframe: modalWireframe, settingsComponentFactory: components.settingsComponentFactory)
        }
    }
    
}
