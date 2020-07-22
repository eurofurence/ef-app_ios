import EurofurenceModel
import UIKit

struct RouterConfigurator {
    
    var router: MutableContentRouter
    var contentWireframe: ContentWireframe
    var modalWireframe: ModalWireframe
    var componentRegistry: ComponentRegistry
    var routeAuthenticationHandler: RouteAuthenticationHandler
    var linksService: ContentLinksService
    var urlOpener: URLOpener
    var window: UIWindow
    
    func configureRoutes() {
        configureAnnouncementsRoute()
        configureAnnouncementRoute()
        configureDealerRoutes()
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
            announcementsComponentFactory: componentRegistry.announcementsModuleFactory,
            contentWireframe: contentWireframe,
            delegate: NavigateFromAnnouncementsToAnnouncement(router: router)
        ))
    }
    
    private func configureAnnouncementRoute() {
        let tabSwapper = MoveToTabByViewController<NewsViewController>(window: window)
        router.add(AnnouncementContentRoute(
            announcementModuleFactory: componentRegistry.announcementDetailComponentFactory,
            contentWireframe: MoveToTabContentWireframe(decoratedWireframe: contentWireframe, tabSwapper: tabSwapper)
        ))
    }
    
    private func configureDealerRoutes() {
        let tabSwapper = MoveToTabByViewController<DealersViewController>(window: window)
        router.add(DealerContentRoute(
            dealerModuleFactory: componentRegistry.dealerDetailModuleProviding,
            contentWireframe: MoveToTabContentWireframe(decoratedWireframe: contentWireframe, tabSwapper: tabSwapper)
        ))
        
        router.add(EmbeddedDealerContentRoute(
            dealerModuleFactory: componentRegistry.dealerDetailModuleProviding, contentWireframe: contentWireframe
        ))
    }
    
    private func configureEventRoute() {
        router.add(EventContentRoute(
            eventModuleFactory: componentRegistry.eventDetailComponentFactory,
            eventDetailDelegate: LeaveFeedbackFromEventNavigator(router: router),
            contentWireframe: contentWireframe
        ))
    }
    
    private func configureEventFeedbackRoute() {
        router.add(EventFeedbackContentRoute(
            eventFeedbackFactory: FormSheetEventFeedbackComponentFactory(
                eventFeedbackComponentFactory: componentRegistry.eventFeedbackComponentFactory
            ),
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureMessageRoute() {
        let tabSwapper = MoveToTabByViewController<NewsViewController>(window: window)
        
        let messageContentRoute = MessageContentRoute(
            messageModuleFactory: componentRegistry.messageDetailComponentFactory,
            contentWireframe: MoveToTabContentWireframe(decoratedWireframe: contentWireframe, tabSwapper: tabSwapper)
        )
        
        router.add(AuthenticatedRoute(
            route: messageContentRoute,
            routeAuthenticationHandler: routeAuthenticationHandler
        ))
    }
    
    private func configureMessagesRoute() {
        let messagesRoute = MessagesContentRoute(
            messagesComponentFactory: componentRegistry.messagesComponentFactory,
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
            loginComponentFactory: componentRegistry.loginComponentFactory
        )
        
        router.add(LoginContentRoute(
            loginModuleFactory: formSheetWrapper,
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureNewsRoute() {
        router.add(NewsContentRoute(
            newsPresentation: ResetNewsAfterLogout(window: window)
        ))
    }
    
    private func configureKnowledgeGroupsRoute() {
        router.add(KnowledgeGroupsContentRoute(
            tabNavigator: MoveToTabByViewController<KnowledgeListViewController>(window: window)
        ))
    }
    
    private func configureKnowledgeEntriesRoute() {
        router.add(KnowledgeGroupContentRoute(
            knowledgeGroupModuleProviding: componentRegistry.knowledgeGroupComponentFactory,
            contentWireframe: contentWireframe,
            delegate: ShowKnowledgeContentFromGroupListing(router: router)
        ))
    }
    
    private func configureKnowledgeDetailRoute() {
        router.add(KnowledgeEntryContentRoute(
            knowledgeDetailComponentFactory: componentRegistry.knowledgeDetailComponentFactory,
            contentWireframe: contentWireframe,
            delegate: OpenLinkFromKnowledgeEntry(router: router, linksService: linksService)
        ))
    }
    
    private func configureMapsRoute() {
        router.add(MapContentRoute(
            mapModuleProviding: componentRegistry.mapDetailComponentFactory,
            contentWireframe: contentWireframe,
            delegate: ShowDealerFromMap(router: router)
        ))
    }
    
    private func configureWebContentRoute() {
        router.add(WebContentRoute(
            webComponentFactory: componentRegistry.webComponentFactory,
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureExternalApplicationContentRoute() {
        router.add(ExternalApplicationContentRoute(urlOpener: urlOpener))
    }
    
}
