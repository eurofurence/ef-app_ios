import EurofurenceModel
import UIKit

struct RouterConfigurator {
    
    var router: MutableContentRouter
    var contentWireframe: ContentWireframe
    var modalWireframe: ModalWireframe
    var moduleRepository: ApplicationModuleRepository
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
    
    private func configureKnowledgeEntriesRoute() {
        router.add(KnowledgeGroupContentRoute(
            knowledgeGroupModuleProviding: moduleRepository.knowledgeGroupEntriesModule,
            contentWireframe: contentWireframe,
            delegate: ShowKnowledgeContentFromGroupListing(router: router)
        ))
    }
    
    private func configureKnowledgeDetailRoute() {
        router.add(KnowledgeEntryContentRoute(
            knowledgeDetailModuleProviding: moduleRepository.knowledgeDetailModuleProviding,
            contentWireframe: contentWireframe,
            delegate: OpenLinkFromKnowledgeEntry(router: router, linksService: linksService)
        ))
    }
    
    private func configureMapsRoute() {
        struct DummyMapDetailModuleDelegate: MapDetailModuleDelegate {
            
            func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
                
            }
            
        }
        
        router.add(MapContentRoute(
            mapModuleProviding: moduleRepository.mapDetailModuleProviding,
            contentWireframe: contentWireframe,
            delegate: DummyMapDetailModuleDelegate()
        ))
    }
    
    private func configureWebContentRoute() {
        router.add(WebContentRoute(
            webModuleProviding: moduleRepository.webModuleProviding,
            modalWireframe: modalWireframe
        ))
    }
    
    private func configureExternalApplicationContentRoute() {
        router.add(ExternalApplicationContentRoute(urlOpener: urlOpener))
    }
    
}
