import EurofurenceModel
import UIKit.UIViewController

class DirectorBuilder {

    private var animate: Bool
    private var linkLookupService: ContentLinksService
    private var webModuleProviding: WebModuleProviding
    private var windowWireframe: WindowWireframe
    private var navigationControllerFactory: NavigationControllerFactory
    private var rootModuleProviding: RootModuleProviding
    private var tutorialModuleProviding: TutorialModuleProviding
    private var preloadModuleProviding: PreloadModuleProviding
    private var tabModuleProviding: TabModuleProviding
    private var newsModuleProviding: NewsModuleProviding
    private var scheduleModuleProviding: ScheduleModuleProviding
    private var dealersModuleProviding: DealersModuleProviding
    private var dealerDetailModuleProviding: DealerDetailModuleProviding
    private var collectThemAllModuleProviding: CollectThemAllModuleProviding
    private var messagesModuleProviding: MessagesModuleProviding
    private var loginModuleProviding: LoginModuleProviding
    private var messageDetailModuleProviding: MessageDetailModuleProviding
    private var knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding
    private var knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding
    private var knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    private var mapsModuleProviding: MapsModuleProviding
    private var mapDetailModuleProviding: MapDetailModuleProviding
    private var announcementsModuleFactory: AnnouncementsModuleProviding
    private var announcementDetailModuleProviding: AnnouncementDetailModuleProviding
    private var eventDetailModuleProviding: EventDetailModuleProviding
    private var urlOpener: URLOpener
    private var notificationHandling: NotificationService
    private var orderingPolicy: ModuleOrderingPolicy
    private var eventFeedbackModule: EventFeedbackModuleProviding

    init(linkLookupService: ContentLinksService, notificationHandling: NotificationService) {
        animate = true
        windowWireframe = AppWindowWireframe.shared
        navigationControllerFactory = PlatformNavigationControllerFactory()
        tabModuleProviding = PlatformTabModuleFactory()

        orderingPolicy = RestorationIdentifierOrderingPolicy()
        rootModuleProviding = RootModuleBuilder().build()
        tutorialModuleProviding = TutorialModuleBuilder().build()
        preloadModuleProviding = PreloadModuleBuilder().build()
        newsModuleProviding = NewsModuleBuilder().build()
        scheduleModuleProviding = ScheduleModuleBuilder().build()
        dealersModuleProviding = DealersModuleBuilder().build()
        dealerDetailModuleProviding = DealerDetailModuleBuilder().build()
        collectThemAllModuleProviding = CollectThemAllModuleBuilder().build()
        messagesModuleProviding = MessagesModuleBuilder().build()
        loginModuleProviding = LoginModuleBuilder().build()
        messageDetailModuleProviding = MessageDetailModuleBuilder().build()
        knowledgeListModuleProviding = KnowledgeGroupsModuleBuilder().build()
        knowledgeGroupEntriesModule = KnowledgeGroupEntriesModuleBuilder().build()
        knowledgeDetailModuleProviding = KnowledgeDetailModuleBuilder().build()
        mapsModuleProviding = MapsModuleBuilder().build()
        mapDetailModuleProviding = MapDetailModuleBuilder().build()
        announcementsModuleFactory = AnnouncementsModuleBuilder().build()
        announcementDetailModuleProviding = AnnouncementDetailModuleBuilder().build()
        eventDetailModuleProviding = EventDetailModuleBuilder().build()
        eventFeedbackModule = EventFeedbackModuleProvidingImpl()

        self.linkLookupService = linkLookupService
        webModuleProviding = SafariWebModuleProviding()
        urlOpener = AppURLOpener()
        self.notificationHandling = notificationHandling
    }

    @discardableResult
    func withAnimations(_ animate: Bool) -> DirectorBuilder {
        self.animate = animate
        return self
    }

    @discardableResult
    func with(_ orderingPolicy: ModuleOrderingPolicy) -> DirectorBuilder {
        self.orderingPolicy = orderingPolicy
        return self
    }

    @discardableResult
    func with(_ windowWireframe: WindowWireframe) -> DirectorBuilder {
        self.windowWireframe = windowWireframe
        return self
    }

    @discardableResult
    func with(_ navigationControllerFactory: NavigationControllerFactory) -> DirectorBuilder {
        self.navigationControllerFactory = navigationControllerFactory
        return self
    }

    @discardableResult
    func with(_ rootModuleProviding: RootModuleProviding) -> DirectorBuilder {
        self.rootModuleProviding = rootModuleProviding
        return self
    }

    @discardableResult
    func with(_ tutorialModuleProviding: TutorialModuleProviding) -> DirectorBuilder {
        self.tutorialModuleProviding = tutorialModuleProviding
        return self
    }

    @discardableResult
    func with(_ preloadModuleProviding: PreloadModuleProviding) -> DirectorBuilder {
        self.preloadModuleProviding = preloadModuleProviding
        return self
    }

    @discardableResult
    func with(_ tabModuleProviding: TabModuleProviding) -> DirectorBuilder {
        self.tabModuleProviding = tabModuleProviding
        return self
    }

    @discardableResult
    func with(_ newsModuleProviding: NewsModuleProviding) -> DirectorBuilder {
        self.newsModuleProviding = newsModuleProviding
        return self
    }

    @discardableResult
    func with(_ scheduleModuleProviding: ScheduleModuleProviding) -> DirectorBuilder {
        self.scheduleModuleProviding = scheduleModuleProviding
        return self
    }

    @discardableResult
    func with(_ dealersModuleProviding: DealersModuleProviding) -> DirectorBuilder {
        self.dealersModuleProviding = dealersModuleProviding
        return self
    }

    @discardableResult
    func with(_ dealerDetailModuleProviding: DealerDetailModuleProviding) -> DirectorBuilder {
        self.dealerDetailModuleProviding = dealerDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ collectThemAllModuleProviding: CollectThemAllModuleProviding) -> DirectorBuilder {
        self.collectThemAllModuleProviding = collectThemAllModuleProviding
        return self
    }

    @discardableResult
    func with(_ messagesModuleProviding: MessagesModuleProviding) -> DirectorBuilder {
        self.messagesModuleProviding = messagesModuleProviding
        return self
    }

    @discardableResult
    func with(_ loginModuleProviding: LoginModuleProviding) -> DirectorBuilder {
        self.loginModuleProviding = loginModuleProviding
        return self
    }

    @discardableResult
    func with(_ messageDetailModuleProviding: MessageDetailModuleProviding) -> DirectorBuilder {
        self.messageDetailModuleProviding = messageDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding) -> DirectorBuilder {
        self.knowledgeListModuleProviding = knowledgeListModuleProviding
        return self
    }

    @discardableResult
    func with(_ knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding) -> DirectorBuilder {
        self.knowledgeGroupEntriesModule = knowledgeGroupEntriesModule
        return self
    }

    @discardableResult
    func with(_ knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding) -> DirectorBuilder {
        self.knowledgeDetailModuleProviding = knowledgeDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ mapsModuleProviding: MapsModuleProviding) -> DirectorBuilder {
        self.mapsModuleProviding = mapsModuleProviding
        return self
    }

    @discardableResult
    func with(_ mapDetailModule: MapDetailModuleProviding) -> DirectorBuilder {
        self.mapDetailModuleProviding = mapDetailModule
        return self
    }

    @discardableResult
    func with(_ announcementsModuleFactory: AnnouncementsModuleProviding) -> DirectorBuilder {
        self.announcementsModuleFactory = announcementsModuleFactory
        return self
    }

    @discardableResult
    func with(_ announcementDetailModuleProviding: AnnouncementDetailModuleProviding) -> DirectorBuilder {
        self.announcementDetailModuleProviding = announcementDetailModuleProviding
        return self
    }

    @discardableResult
    func with(_ webModuleProviding: WebModuleProviding) -> DirectorBuilder {
        self.webModuleProviding = webModuleProviding
        return self
    }

    @discardableResult
    func with(_ urlOpener: URLOpener) -> DirectorBuilder {
        self.urlOpener = urlOpener
        return self
    }

    @discardableResult
    func with(_ eventDetailModuleProviding: EventDetailModuleProviding) -> DirectorBuilder {
        self.eventDetailModuleProviding = eventDetailModuleProviding
        return self
    }
    
    @discardableResult
    func with(_ eventFeedbackModule: EventFeedbackModuleProviding) -> DirectorBuilder {
        self.eventFeedbackModule = eventFeedbackModule
        return self
    }

    func build() -> ApplicationDirector {
        let moduleRepository = makeApplicationModuleRepository()
        
        return ApplicationDirector(animate: animate,
                                   moduleRepository: moduleRepository,
                                   linkLookupService: linkLookupService,
                                   urlOpener: urlOpener,
                                   orderingPolicy: orderingPolicy,
                                   windowWireframe: windowWireframe,
                                   navigationControllerFactory: navigationControllerFactory,
                                   tabModuleProviding: tabModuleProviding,
                                   notificationHandling: notificationHandling)
    }
    
    private func makeApplicationModuleRepository() -> ModuleAggregation {
        return ModuleAggregation(webModuleProviding: webModuleProviding,
                                 rootModuleProviding: rootModuleProviding,
                                 tutorialModuleProviding: tutorialModuleProviding,
                                 preloadModuleProviding: preloadModuleProviding,
                                 newsModuleProviding: newsModuleProviding,
                                 scheduleModuleProviding: scheduleModuleProviding,
                                 dealersModuleProviding: dealersModuleProviding,
                                 dealerDetailModuleProviding: dealerDetailModuleProviding,
                                 collectThemAllModuleProviding: collectThemAllModuleProviding,
                                 messagesModuleProviding: messagesModuleProviding,
                                 loginModuleProviding: loginModuleProviding,
                                 messageDetailModuleProviding: messageDetailModuleProviding,
                                 knowledgeListModuleProviding: knowledgeListModuleProviding,
                                 knowledgeGroupEntriesModule: knowledgeGroupEntriesModule,
                                 knowledgeDetailModuleProviding: knowledgeDetailModuleProviding,
                                 mapsModuleProviding: mapsModuleProviding,
                                 mapDetailModuleProviding: mapDetailModuleProviding,
                                 announcementsModuleFactory: announcementsModuleFactory,
                                 announcementDetailModuleProviding: announcementDetailModuleProviding,
                                 eventDetailModuleProviding: eventDetailModuleProviding,
                                 eventFeedbackModuleProviding: eventFeedbackModule)
    }

}
