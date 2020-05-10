import EurofurenceModel
import UIKit

struct ApplicationModuleRepository {
    
    let webModuleProviding: WebModuleProviding
    let tutorialModuleProviding: TutorialModuleProviding
    let preloadModuleProviding: PreloadModuleProviding
    let newsModuleProviding: NewsModuleProviding
    let scheduleComponentFactory: ScheduleComponentFactory
    let dealersComponentFactory: DealersComponentFactory
    let dealerDetailModuleProviding: DealerDetailComponentFactory
    let collectThemAllComponentFactory: CollectThemAllComponentFactory
    let messagesModuleProviding: MessagesModuleProviding
    let loginModuleProviding: LoginModuleProviding
    let messageDetailModuleProviding: MessageDetailModuleProviding
    let knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding
    let knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding
    let knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    let mapsModuleProviding: MapsModuleProviding
    let mapDetailModuleProviding: MapDetailModuleProviding
    let announcementsModuleFactory: AnnouncementsComponentFactory
    let announcementDetailComponentFactory: AnnouncementDetailComponentFactory
    let eventDetailComponentFactory: EventDetailComponentFactory
    let eventFeedbackComponentFactory: EventFeedbackComponentFactory
    let additionalServicesComponentFactory: AdditionalServicesComponentFactory
    
    // swiftlint:disable function_body_length
    init(services: Services, repositories: Repositories, window: UIWindow) {
        let subtleMarkdownRenderer = SubtleDownMarkdownRenderer()
        let defaultMarkdownRenderer = DefaultDownMarkdownRenderer()
        let shareService = ActivityShareService(window: window)
        let activityFactory = PlatformActivityFactory()
        let alertRouter = WindowAlertRouter(window: window)
        
        tutorialModuleProviding = TutorialModuleBuilder(alertRouter: alertRouter).build()
        
        let preloadInteractor = ApplicationPreloadInteractor(refreshService: services.refresh)
        preloadModuleProviding = PreloadModuleBuilder(
            preloadInteractor: preloadInteractor,
            alertRouter: alertRouter
        ).build()
        
        let newsInteractor = DefaultNewsInteractor(announcementsService: services.announcements,
                                                   authenticationService: services.authentication,
                                                   privateMessagesService: services.privateMessages,
                                                   daysUntilConventionService: services.conventionCountdown,
                                                   eventsService: services.events,
                                                   relativeTimeIntervalCountdownFormatter: FoundationRelativeTimeIntervalCountdownFormatter.shared,
                                                   hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                   clock: SystemClock.shared,
                                                   refreshService: services.refresh,
                                                   announcementsDateFormatter: FoundationAnnouncementDateFormatter.shared,
                                                   announcementsMarkdownRenderer: subtleMarkdownRenderer)
        newsModuleProviding = NewsModuleBuilder(newsInteractor: newsInteractor).build()
        
        let scheduleInteractor = DefaultScheduleInteractor(eventsService: services.events,
                                                           hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                           shortFormDateFormatter: FoundationShortFormDateFormatter.shared,
                                                           shortFormDayAndTimeFormatter: FoundationShortFormDayAndTimeFormatter.shared,
                                                           refreshService: services.refresh)
        scheduleComponentFactory = ScheduleModuleBuilder(interactor: scheduleInteractor).build()
        
        let defaultDealerIcon = #imageLiteral(resourceName: "defaultAvatar")
        guard let defaultDealerIconData = defaultDealerIcon.pngData() else { fatalError("Default dealer icon is not a PNG") }
        let dealersInteractor = DefaultDealersViewModelFactory(dealersService: services.dealers, defaultIconData: defaultDealerIconData, refreshService: services.refresh)
        dealersComponentFactory = DealersComponentBuilder(interactor: dealersInteractor).build()
        
        let dealerIntentDonor = ConcreteViewDealerIntentDonor()
        let dealerInteractionRecorder = DonateIntentDealerInteractionRecorder(
            viewDealerIntentDonor: dealerIntentDonor,
            dealersService: services.dealers,
            activityFactory: activityFactory
        )
        
        let dealerDetailInteractor = DefaultDealerDetailViewModelFactory(dealersService: services.dealers, shareService: shareService)
        dealerDetailModuleProviding = DealerDetailComponentBuilder(dealerDetailInteractor: dealerDetailInteractor, dealerInteractionRecorder: dealerInteractionRecorder).build()
        
        collectThemAllComponentFactory = CollectThemAllComponentBuilder(service: services.collectThemAll).build()
        messagesModuleProviding = MessagesModuleBuilder(authenticationService: services.authentication, privateMessagesService: services.privateMessages).build()
        
        loginModuleProviding = LoginModuleBuilder(
            authenticationService: services.authentication,
            alertRouter: alertRouter
        ).build()
        
        messageDetailModuleProviding = MessageDetailModuleBuilder(messagesService: services.privateMessages).build()
        
        let knowledgeListInteractor = DefaultKnowledgeGroupsInteractor(service: services.knowledge)
        knowledgeListModuleProviding = KnowledgeGroupsModuleBuilder(knowledgeListInteractor: knowledgeListInteractor).build()
        
        let knowledgeGroupEntriesInteractor = DefaultKnowledgeGroupEntriesInteractor(service: services.knowledge)
        knowledgeGroupEntriesModule = KnowledgeGroupEntriesModuleBuilder(interactor: knowledgeGroupEntriesInteractor).build()
        
        let knowledgeDetailSceneInteractor = DefaultKnowledgeDetailSceneInteractor(
            knowledgeService: services.knowledge,
            renderer: defaultMarkdownRenderer,
            shareService: shareService
        )
        
        knowledgeDetailModuleProviding = KnowledgeDetailModuleBuilder(knowledgeDetailSceneInteractor: knowledgeDetailSceneInteractor).build()
        
        let mapsInteractor = DefaultMapsInteractor(mapsService: services.maps)
        mapsModuleProviding = MapsModuleBuilder(interactor: mapsInteractor).build()
        
        let mapDetailInteractor = DefaultMapDetailInteractor(mapsService: services.maps)
        mapDetailModuleProviding = MapDetailModuleBuilder(interactor: mapDetailInteractor).build()
        
        let announcementsViewModelFactory = DefaultAnnouncementsViewModelFactory(announcementsService: services.announcements,
                                                                     announcementDateFormatter: FoundationAnnouncementDateFormatter.shared,
                                                                     markdownRenderer: subtleMarkdownRenderer)
        announcementsModuleFactory = AnnouncementsComponentBuilder(announcementsViewModelFactory: announcementsViewModelFactory).build()
        
        let announcementDetailViewModelFactory = DefaultAnnouncementDetailViewModelFactory(
            announcementsService: services.announcements,
            markdownRenderer: defaultMarkdownRenderer
        )
        
        announcementDetailComponentFactory = AnnouncementDetailComponentBuilder(
            announcementDetailViewModelFactory: announcementDetailViewModelFactory
        ).build()
        
        let eventIntentDonor = ConcreteEventIntentDonor()
        let eventInteractionRecorder = SystemEventInteractionsRecorder(
            eventsService: services.events,
            eventIntentDonor: eventIntentDonor,
            activityFactory: activityFactory
        )
        
        let eventDetailViewModelFactory = DefaultEventDetailViewModelFactory(dateRangeFormatter: FoundationDateRangeFormatter.shared,
                                                                 eventsService: services.events,
                                                                 markdownRenderer: DefaultDownMarkdownRenderer(),
                                                                 shareService: shareService)
        eventDetailComponentFactory = EventDetailComponentBuilder(interactor: eventDetailViewModelFactory, interactionRecorder: eventInteractionRecorder).build()
        
        let eventFeedbackPresenterFactory = EventFeedbackPresenterFactoryImpl(eventService: services.events,
                                                                              dayOfWeekFormatter: FoundationDayOfWeekFormatter.shared,
                                                                              startTimeFormatter: FoundationHoursDateFormatter.shared,
                                                                              endTimeFormatter: FoundationHoursDateFormatter.shared,
                                                                              successHaptic: CocoaTouchSuccessHaptic(),
                                                                              failureHaptic: CocoaTouchFailureHaptic(),
                                                                              successWaitingRule: ShortDelayEventFeedbackSuccessWaitingRule())
        let eventFeedbackSceneFactory = StoryboardEventFeedbackSceneFactory()
        eventFeedbackComponentFactory = EventFeedbackComponentFactoryImpl(presenterFactory: eventFeedbackPresenterFactory, sceneFactory: eventFeedbackSceneFactory)
        
        webModuleProviding = SafariWebModuleProviding()
        
        additionalServicesComponentFactory = AdditionalServicesComponentBuilder(repository: repositories.additionalServices).build()
    }
    
}
