import EurofurenceModel
import UIKit

struct RouterConfigurator {
    
    var router: MutableContentRouter
    var contentWireframe: ContentWireframe
    var modalWireframe: ModalWireframe
    var moduleRepository: ApplicationModuleRepository
    var routeAuthenticationHandler: RouteAuthenticationHandler
    var window: UIWindow
    
    func configureRoutes() {
        configureAnnouncementsRoute()
        configureAnnouncementRoute()
        configureDealerRoute()
        configureEventRoute()
        configureEventFeedbackRoute()
        configureMessageRoute()
        configureMessagesRoute()
        configureLoginRoute()
        configureNewsRoute()
    }
    
    private func configureAnnouncementsRoute() {
        router.add(AnnouncementsContentRoute(
            announcementsModuleProviding: moduleRepository.announcementsModuleFactory,
            contentWireframe: contentWireframe,
            delegate: NavigateFromAnnouncementsToAnnouncement(router: router)
        ))
    }
    
    private func configureAnnouncementRoute() {
        router.add(AnnouncementContentRoute(
            announcementModuleFactory: moduleRepository.announcementDetailModuleProviding,
            contentWireframe: contentWireframe
        ))
    }
    
    private func configureDealerRoute() {
        router.add(DealerContentRoute(
            dealerModuleFactory: moduleRepository.dealerDetailModuleProviding,
            contentWireframe: contentWireframe
        ))
    }
    
    private func configureEventRoute() {
        router.add(EventContentRoute(
            eventModuleFactory: moduleRepository.eventDetailModuleProviding,
            eventDetailDelegate: LeaveFeedbackFromEventNavigator(router: router),
            contentWireframe: contentWireframe
        ))
    }
    
    private func configureEventFeedbackRoute() {
        router.add(EventFeedbackContentRoute(
            eventFeedbackFactory: FormSheetEventFeedbackModuleProviding(
                eventFeedbackModuleProviding: moduleRepository.eventFeedbackModuleProviding
            ),
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureMessageRoute() {
        router.add(MessageContentRoute(
            messageModuleFactory: moduleRepository.messageDetailModuleProviding,
            contentWireframe: contentWireframe
        ))
    }
    
    private func configureMessagesRoute() {
        let messagesRoute = MessagesContentRoute(
            messagesModuleProviding: moduleRepository.messagesModuleProviding,
            contentWireframe: contentWireframe,
            delegate: NavigateFromMessagesToMessage(
                router: router,
                modalWireframe: modalWireframe
            )
        )
        
        router.add(AuthenticatedRoute(
            route: messagesRoute,
            routeAuthenticationHandler: routeAuthenticationHandler
        ))
    }
    
    private func configureLoginRoute() {
        let formSheetWrapper = FormSheetLoginModuleProviding(
            loginModuleProviding: moduleRepository.loginModuleProviding
        )
        
        router.add(LoginContentRoute(
            loginModuleFactory: formSheetWrapper,
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureNewsRoute() {
        router.add(NewsContentRoute(
            newsPresentation: ExplicitTabManipulationNewsPresentation(window: window)
        ))
    }
    
}
