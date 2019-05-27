import EurofurenceModel
import UIKit

struct ApplicationModuleRepository: ModuleRepository {
    
    private let webModuleProviding: WebModuleProviding
    private let rootModuleProviding: RootModuleProviding
    private let tutorialModuleProviding: TutorialModuleProviding
    private let preloadModuleProviding: PreloadModuleProviding
    private let newsModuleProviding: NewsModuleProviding
    private let scheduleModuleProviding: ScheduleModuleProviding
    private let dealersModuleProviding: DealersModuleProviding
    private let dealerDetailModuleProviding: DealerDetailModuleProviding
    private let collectThemAllModuleProviding: CollectThemAllModuleProviding
    private let messagesModuleProviding: MessagesModuleProviding
    private let loginModuleProviding: LoginModuleProviding
    private let messageDetailModuleProviding: MessageDetailModuleProviding
    private let knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding
    private let knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding
    private let knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    private let mapsModuleProviding: MapsModuleProviding
    private let mapDetailModuleProviding: MapDetailModuleProviding
    private let announcementsModuleFactory: AnnouncementsModuleProviding
    private let announcementDetailModuleProviding: AnnouncementDetailModuleProviding
    private let eventDetailModuleProviding: EventDetailModuleProviding
    private let eventFeedbackModuleProviding: EventFeedbackModuleProviding
    
    init(services: Services) {
        rootModuleProviding = RootModuleBuilder(sessionStateService: services.sessionState).build()
        tutorialModuleProviding = TutorialModuleBuilder().build()
        preloadModuleProviding = PreloadModuleBuilder().build()
        newsModuleProviding = NewsModuleBuilder().build()
        scheduleModuleProviding = ScheduleModuleBuilder().build()
        
        let defaultDealerIcon = #imageLiteral(resourceName: "defaultAvatar")
        let dealersInteractor = DefaultDealersInteractor(dealersService: services.dealers, defaultIconData: defaultDealerIcon.pngData()!, refreshService: services.refresh)
        dealersModuleProviding = DealersModuleBuilder(interactor: dealersInteractor).build()
        
        let dealerDetailInteractor = DefaultDealerDetailInteractor(dealersService: services.dealers)
        dealerDetailModuleProviding = DealerDetailModuleBuilder(dealerDetailInteractor: dealerDetailInteractor).build()
        
        collectThemAllModuleProviding = CollectThemAllModuleBuilder(service: services.collectThemAll).build()
        messagesModuleProviding = MessagesModuleBuilder().build()
        loginModuleProviding = LoginModuleBuilder().build()
        messageDetailModuleProviding = MessageDetailModuleBuilder().build()
        knowledgeListModuleProviding = KnowledgeGroupsModuleBuilder().build()
        knowledgeGroupEntriesModule = KnowledgeGroupEntriesModuleBuilder().build()
        knowledgeDetailModuleProviding = KnowledgeDetailModuleBuilder().build()
        mapsModuleProviding = MapsModuleBuilder().build()
        mapDetailModuleProviding = MapDetailModuleBuilder().build()
        
        let announcementsInteractor = DefaultAnnouncementsInteractor(announcementsService: services.announcements,
                                                                     announcementDateFormatter: FoundationAnnouncementDateFormatter.shared,
                                                                     markdownRenderer: SubtleDownMarkdownRenderer())
        announcementsModuleFactory = AnnouncementsModuleBuilder(announcementsInteractor: announcementsInteractor).build()
        
        let announcementDetailInteractor = DefaultAnnouncementDetailInteractor(announcementsService: services.announcements,
                                                                               markdownRenderer: DefaultMarkdownRenderer())
        announcementDetailModuleProviding = AnnouncementDetailModuleBuilder(announcementDetailInteractor: announcementDetailInteractor).build()

        let eventDetailInteractor = DefaultEventDetailInteractor(dateRangeFormatter: FoundationDateRangeFormatter.shared,
                                                                 eventsService: services.events,
                                                                 markdownRenderer: DefaultDownMarkdownRenderer())
        eventDetailModuleProviding = EventDetailModuleBuilder(interactor: eventDetailInteractor).build()
        
        eventFeedbackModuleProviding = EventFeedbackModuleProvidingImpl()
        webModuleProviding = SafariWebModuleProviding()
    }
    
    func makeRootModule(_ delegate: RootModuleDelegate) {
        rootModuleProviding.makeRootModule(delegate)
    }
    
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        return tutorialModuleProviding.makeTutorialModule(delegate)
    }
    
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        return preloadModuleProviding.makePreloadModule(delegate)
    }
    
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        return newsModuleProviding.makeNewsModule(delegate)
    }
    
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        return loginModuleProviding.makeLoginModule(delegate)
    }
    
    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController {
        return announcementsModuleFactory.makeAnnouncementsModule(delegate)
    }
    
    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        return announcementDetailModuleProviding.makeAnnouncementDetailModule(for: announcement)
    }
    
    func makeEventDetailModule(for event: EventIdentifier, delegate: EventDetailModuleDelegate) -> UIViewController {
        return eventDetailModuleProviding.makeEventDetailModule(for: event, delegate: delegate)
    }
    
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        return eventFeedbackModuleProviding.makeEventFeedbackModule(for: event, delegate: delegate)
    }
    
    func makeWebModule(for url: URL) -> UIViewController {
        return webModuleProviding.makeWebModule(for: url)
    }
    
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        return messagesModuleProviding.makeMessagesModule(delegate)
    }
    
    func makeMessageDetailModule(message: Message) -> UIViewController {
        return messageDetailModuleProviding.makeMessageDetailModule(message: message)
    }
    
    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        return scheduleModuleProviding.makeScheduleModule(delegate)
    }
    
    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController {
        return dealersModuleProviding.makeDealersModule(delegate)
    }
    
    func makeDealerDetailModule(for identifier: DealerIdentifier) -> UIViewController {
        return dealerDetailModuleProviding.makeDealerDetailModule(for: identifier)
    }
    
    func makeKnowledgeListModule(_ delegate: KnowledgeGroupsListModuleDelegate) -> UIViewController {
        return knowledgeListModuleProviding.makeKnowledgeListModule(delegate)
    }
    
    func makeKnowledgeDetailModule(_ identifier: KnowledgeEntryIdentifier, delegate: KnowledgeDetailModuleDelegate) -> UIViewController {
        return knowledgeDetailModuleProviding.makeKnowledgeListModule(identifier, delegate: delegate)
    }
    
    func makeKnowledgeGroupEntriesModule(_ knowledgeGroup: KnowledgeGroupIdentifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController {
        return knowledgeGroupEntriesModule.makeKnowledgeGroupEntriesModule(knowledgeGroup, delegate: delegate)
    }
    
    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController {
        return mapsModuleProviding.makeMapsModule(delegate)
    }
    
    func makeMapDetailModule(for identifier: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        return mapDetailModuleProviding.makeMapDetailModule(for: identifier, delegate: delegate)
    }
    
    func makeCollectThemAllModule() -> UIViewController {
        return collectThemAllModuleProviding.makeCollectThemAllModule()
    }
    
}
