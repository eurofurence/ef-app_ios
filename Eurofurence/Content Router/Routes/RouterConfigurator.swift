import EurofurenceModel
import UIKit

struct RouterConfigurator {
    
    var router: MutableContentRouter
    var contentWireframe: ContentWireframe
    var modalWireframe: ModalWireframe
    var moduleRepository: ComponentRegistry
    var routeAuthenticationHandler: RouteAuthenticationHandler
    var linksService: ContentLinksService
    var urlOpener: URLOpener
    var window: UIWindow
    
    func configureRoutes() {
        configureAnnouncementsRoute()
        configureAnnouncementRoute()
        configureDealerRoute()
        configureEventRoute()
        configureEventFeedbackRoute()
        configureKnowledgeGroupsRoute()
        configureKnowledgeEntriesRoute()
        configureKnowledgeDetailRoute()
        configureMapsRoute()
        configureMessageRoute()
        configureMessagesRoute()
        configureLoginRoute()
        configureNewsRoute()
        configureWebContentRoute()
        configureExternalApplicationContentRoute()
    }
    
    private func configureAnnouncementsRoute() {
        router.add(AnnouncementsContentRoute(
            announcementsComponentFactory: moduleRepository.announcementsModuleFactory,
            contentWireframe: contentWireframe,
            delegate: NavigateFromAnnouncementsToAnnouncement(router: router)
        ))
    }
    
    private func configureAnnouncementRoute() {
        router.add(AnnouncementContentRoute(
            announcementModuleFactory: moduleRepository.announcementDetailComponentFactory,
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
            eventModuleFactory: moduleRepository.eventDetailComponentFactory,
            eventDetailDelegate: LeaveFeedbackFromEventNavigator(router: router),
            contentWireframe: contentWireframe
        ))
    }
    
    private func configureEventFeedbackRoute() {
        router.add(EventFeedbackContentRoute(
            eventFeedbackFactory: FormSheetEventFeedbackComponentFactory(
                eventFeedbackComponentFactory: moduleRepository.eventFeedbackComponentFactory
            ),
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureMessageRoute() {
        let messageContentRoute = MessageContentRoute(
            messageModuleFactory: moduleRepository.messageDetailComponentFactory,
            contentWireframe: contentWireframe
        )
        
        router.add(AuthenticatedRoute(
            route: messageContentRoute,
            routeAuthenticationHandler: routeAuthenticationHandler
        ))
    }
    
    private func configureMessagesRoute() {
        let messagesRoute = MessagesContentRoute(
            messagesComponentFactory: moduleRepository.messagesComponentFactory,
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
        let formSheetWrapper = FormSheetLoginComponentFactory(
            loginComponentFactory: moduleRepository.loginComponentFactory
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
    
    private func configureKnowledgeGroupsRoute() {
        router.add(KnowledgeGroupsContentRoute(
            tabNavigator: MoveToTabByViewController<KnowledgeListViewController>(window: window)
        ))
    }
    
    private func configureKnowledgeEntriesRoute() {
        router.add(KnowledgeGroupContentRoute(
            knowledgeGroupModuleProviding: moduleRepository.knowledgeGroupComponentFactory,
            contentWireframe: contentWireframe,
            delegate: ShowKnowledgeContentFromGroupListing(router: router)
        ))
    }
    
    private func configureKnowledgeDetailRoute() {
        router.add(KnowledgeEntryContentRoute(
            knowledgeDetailComponentFactory: moduleRepository.knowledgeDetailComponentFactory,
            contentWireframe: contentWireframe,
            delegate: OpenLinkFromKnowledgeEntry(router: router, linksService: linksService)
        ))
    }
    
    private func configureMapsRoute() {
        router.add(MapContentRoute(
            mapModuleProviding: moduleRepository.mapDetailComponentFactory,
            contentWireframe: contentWireframe,
            delegate: ShowDealerFromMap(router: router)
        ))
    }
    
    private func configureWebContentRoute() {
        router.add(WebContentRoute(
            webComponentFactory: moduleRepository.webComponentFactory,
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureExternalApplicationContentRoute() {
        router.add(ExternalApplicationContentRoute(urlOpener: urlOpener))
    }
    
}
