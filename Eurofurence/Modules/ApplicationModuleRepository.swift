import EurofurenceModel
import UIKit

struct ApplicationModuleRepository {
    
    let webComponentFactory: WebComponentFactory
    let tutorialModuleProviding: TutorialModuleProviding
    let preloadComponentFactory: PreloadComponentFactory
    let newsComponentFactory: NewsComponentFactory
    let scheduleComponentFactory: ScheduleComponentFactory
    let dealersComponentFactory: DealersComponentFactory
    let dealerDetailModuleProviding: DealerDetailComponentFactory
    let collectThemAllComponentFactory: CollectThemAllComponentFactory
    let messagesComponentFactory: MessagesComponentFactory
    let loginComponentFactory: LoginComponentFactory
    let messageDetailComponentFactory: MessageDetailComponentFactory
    let knowledgeListModuleProviding: KnowledgeGroupsListComponentFactory
    let knowledgeGroupEntriesModule: KnowledgeGroupEntriesComponentFactory
    let knowledgeDetailComponentFactory: KnowledgeDetailComponentFactory
    let mapsComponentFactory: MapsComponentFactory
    let mapDetailModuleProviding: MapDetailComponentFactory
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
        preloadComponentFactory = PreloadComponentBuilder(
            preloadInteractor: preloadInteractor,
            alertRouter: alertRouter
        ).build()
        
        let newsInteractor = DefaultNewsViewModelProducer(announcementsService: services.announcements,
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
        newsComponentFactory = NewsComponentBuilder(newsInteractor: newsInteractor).build()
        
        let scheduleViewModelFactory = DefaultScheduleViewModelFactory(eventsService: services.events,
                                                           hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                           shortFormDateFormatter: FoundationShortFormDateFormatter.shared,
                                                           shortFormDayAndTimeFormatter: FoundationShortFormDayAndTimeFormatter.shared,
                                                           refreshService: services.refresh)
        scheduleComponentFactory = ScheduleModuleBuilder(interactor: scheduleViewModelFactory).build()
        
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
        messagesComponentFactory = MessagesComponentBuilder(authenticationService: services.authentication, privateMessagesService: services.privateMessages).build()
        
        loginComponentFactory = LoginComponentBuilder(
            authenticationService: services.authentication,
            alertRouter: alertRouter
        ).build()
        
        messageDetailComponentFactory = MessageDetailComponentBuilder(messagesService: services.privateMessages).build()
        
        let knowledgeListInteractor = DefaultKnowledgeGroupsViewModelFactory(service: services.knowledge)
        knowledgeListModuleProviding = KnowledgeGroupsComponentBuilder(knowledgeListInteractor: knowledgeListInteractor).build()
        
        let knowledgeGroupEntriesInteractor = DefaultKnowledgeGroupViewModelFactory(service: services.knowledge)
        knowledgeGroupEntriesModule = KnowledgeGroupEntriesComponentBuilder(interactor: knowledgeGroupEntriesInteractor).build()
        
        let knowledgeDetailViewModelFactory = DefaultKnowledgeDetailViewModelFactory(
            knowledgeService: services.knowledge,
            renderer: defaultMarkdownRenderer,
            shareService: shareService
        )
        
        knowledgeDetailComponentFactory = KnowledgeDetailComponentBuilder(
            knowledgeDetailViewModelFactory: knowledgeDetailViewModelFactory
        ).build()
        
        let mapsInteractor = DefaultMapsViewModelFactory(mapsService: services.maps)
        mapsComponentFactory = MapsComponentBuilder(interactor: mapsInteractor).build()
        
        let mapDetailViewModelFactory = DefaultMapDetailViewModelFactory(mapsService: services.maps)
        mapDetailModuleProviding = MapDetailComponentBuilder(interactor: mapDetailViewModelFactory).build()
        
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
        
        webComponentFactory = SafariWebComponentFactory()
        
        additionalServicesComponentFactory = AdditionalServicesComponentBuilder(repository: repositories.additionalServices).build()
    }
    
}
