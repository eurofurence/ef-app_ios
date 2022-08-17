import ComponentBase
import DealerComponent
import DealersComponent
import EurofurenceModel
import EventDetailComponent
import EventFeedbackComponent
import KnowledgeDetailComponent
import KnowledgeGroupComponent
import KnowledgeGroupsComponent
import PreloadComponent
import ScheduleComponent
import TutorialComponent
import UIKit

struct ComponentRegistry {
    
    let webComponentFactory: WebComponentFactory
    let tutorialComponentFactory: TutorialComponentFactory
    let preloadComponentFactory: PreloadComponentFactory
    let newsComponentFactory: NewsComponentFactory
    let scheduleComponentFactory: ScheduleComponentFactory
    let dealersComponentFactory: DealersComponentFactory
    let dealerDetailModuleProviding: DealerDetailComponentFactory
    let collectThemAllComponentFactory: CollectThemAllComponentFactory
    let messagesComponentFactory: MessagesComponentFactory
    let loginComponentFactory: LoginComponentFactory
    let messageDetailComponentFactory: MessageDetailComponentFactory
    let knowledgeListComponentFactory: KnowledgeGroupsListComponentFactory
    let knowledgeGroupComponentFactory: KnowledgeGroupEntriesComponentFactory
    let knowledgeDetailComponentFactory: KnowledgeDetailComponentFactory
    let mapsComponentFactory: MapsComponentFactory
    let mapDetailComponentFactory: MapDetailComponentFactory
    let announcementsModuleFactory: AnnouncementsComponentFactory
    let announcementDetailComponentFactory: AnnouncementDetailComponentFactory
    let eventDetailComponentFactory: EventDetailComponentFactory
    let eventFeedbackComponentFactory: EventFeedbackComponentFactory
    let additionalServicesComponentFactory: AdditionalServicesComponentFactory
    let settingsComponentFactory: SettingsComponentFactory
    
    // swiftlint:disable function_body_length
    init(dependencies: Application.Dependencies, services: Services, repositories: Repositories, window: UIWindow) {
        let subtleMarkdownRenderer = SubtleDownMarkdownRenderer()
        let defaultMarkdownRenderer = DefaultDownMarkdownRenderer()
        let shareService = ActivityShareService(window: window)
        let activityFactory = PlatformActivityFactory()
        let alertRouter = WindowAlertRouter(window: window)
        
        tutorialComponentFactory = TutorialModuleBuilder(alertRouter: alertRouter).build()
        
        let preloadInteractor = ApplicationPreloadInteractor(refreshService: services.refresh)
        preloadComponentFactory = PreloadComponentBuilder(
            preloadInteractor: preloadInteractor,
            alertRouter: alertRouter
        ).build()
        
        newsComponentFactory = CompositionalNewsComponentDefaultWidgetsBuilder(
            repositories: repositories,
            services: services
        ).buildNewsComponent()
        
        let scheduleViewModelFactory = DefaultScheduleViewModelFactory(
            eventsService: repositories.events,
            hoursDateFormatter: FoundationHoursDateFormatter.shared,
            shortFormDateFormatter: FoundationShortFormDateFormatter.shared,
            shortFormDayAndTimeFormatter: FoundationShortFormDayAndTimeFormatter.shared,
            refreshService: services.refresh,
            shareService: shareService
        )
        
        scheduleComponentFactory = ScheduleModuleBuilder(
            scheduleViewModelFactory: scheduleViewModelFactory
        ).build()
        
        let dealersViewModelFactory = DefaultDealersViewModelFactory(
            dealersService: services.dealers,
            refreshService: services.refresh
        )
        
        dealersComponentFactory = DealersComponentBuilder(
            dealersViewModelFactory: dealersViewModelFactory
        ).build()
        
        let dealerInteractionRecorder = DonateIntentDealerInteractionRecorder(
            viewDealerIntentDonor: dependencies.viewDealerIntentDonor,
            dealersService: services.dealers,
            activityFactory: activityFactory
        )
        
        let dealerDetailViewModelFactory = DefaultDealerDetailViewModelFactory(
            dealersService: services.dealers,
            shareService: shareService
        )

        dealerDetailModuleProviding = DealerDetailComponentBuilder(
            dealerDetailViewModelFactory: dealerDetailViewModelFactory,
            dealerInteractionRecorder: dealerInteractionRecorder
        ).build()
        
        collectThemAllComponentFactory = CollectThemAllComponentBuilder(
            service: services.collectThemAll
        ).build()
        
        messagesComponentFactory = MessagesComponentBuilder(
            authenticationService: services.authentication,
            privateMessagesService: services.privateMessages
        ).build()
        
        loginComponentFactory = LoginComponentBuilder(
            authenticationService: services.authentication,
            alertRouter: alertRouter
        ).build()
        
        messageDetailComponentFactory = MessageDetailComponentBuilder(
            messagesService: services.privateMessages
        ).build()
        
        let knowledgeGroupsViewModelFactory = DefaultKnowledgeGroupsViewModelFactory(
            service: services.knowledge
        )
        
        knowledgeListComponentFactory = KnowledgeGroupsComponentBuilder(
            knowledgeGroupsViewModelFactory: knowledgeGroupsViewModelFactory
        ).build()
        
        let knowledgeGroupViewModelFactory = DefaultKnowledgeGroupViewModelFactory(
            service: services.knowledge
        )
        
        knowledgeGroupComponentFactory = KnowledgeGroupEntriesComponentBuilder(
            knowledgeGroupViewModelFactory: knowledgeGroupViewModelFactory
        ).build()
        
        let knowledgeDetailViewModelFactory = DefaultKnowledgeDetailViewModelFactory(
            knowledgeService: services.knowledge,
            renderer: defaultMarkdownRenderer,
            shareService: shareService
        )
        
        knowledgeDetailComponentFactory = KnowledgeDetailComponentBuilder(
            knowledgeDetailViewModelFactory: knowledgeDetailViewModelFactory
        ).build()
        
        let mapsViewModelFactory = DefaultMapsViewModelFactory(mapsService: services.maps)
        
        mapsComponentFactory = MapsComponentBuilder(
            mapsViewModelFactory: mapsViewModelFactory
        ).build()
        
        let mapDetailViewModelFactory = DefaultMapDetailViewModelFactory(mapsService: services.maps)
        
        mapDetailComponentFactory = MapDetailComponentBuilder(
            mapDetailViewModelFactory: mapDetailViewModelFactory
        ).build()
        
        let announcementsViewModelFactory = DefaultAnnouncementsViewModelFactory(
            announcementsService: repositories.announcements,
            announcementDateFormatter: FoundationAnnouncementDateFormatter.shared,
            markdownRenderer: subtleMarkdownRenderer
        )
        
        announcementsModuleFactory = AnnouncementsComponentBuilder(
            announcementsViewModelFactory: announcementsViewModelFactory
        ).build()
        
        let announcementDetailViewModelFactory = DefaultAnnouncementDetailViewModelFactory(
            announcementsService: repositories.announcements,
            markdownRenderer: defaultMarkdownRenderer
        )
        
        announcementDetailComponentFactory = AnnouncementDetailComponentBuilder(
            announcementDetailViewModelFactory: announcementDetailViewModelFactory
        ).build()
        
        let eventInteractionRecorder = SystemEventInteractionsRecorder(
            eventsService: repositories.events,
            eventIntentDonor: dependencies.viewEventIntentDonor,
            activityFactory: activityFactory
        )
        
        let eventDetailViewModelFactory = DefaultEventDetailViewModelFactory(
            dateRangeFormatter: FoundationDateRangeFormatter.shared,
            eventsService: repositories.events,
            markdownRenderer: DefaultDownMarkdownRenderer(),
            shareService: shareService
        )
        
        eventDetailComponentFactory = EventDetailComponentBuilder(
            eventDetailViewModelFactory: eventDetailViewModelFactory,
            interactionRecorder: eventInteractionRecorder
        ).build()
        
        let eventFeedbackPresenterFactory = EventFeedbackPresenterFactoryImpl(
            eventService: repositories.events,
            dayOfWeekFormatter: FoundationDayOfWeekFormatter.shared,
            startTimeFormatter: FoundationHoursDateFormatter.shared,
            endTimeFormatter: FoundationHoursDateFormatter.shared,
            successHaptic: CocoaTouchSuccessHaptic(),
            failureHaptic: CocoaTouchFailureHaptic(),
            successWaitingRule: ShortDelayEventFeedbackSuccessWaitingRule()
        )
        
        let eventFeedbackSceneFactory = StoryboardEventFeedbackSceneFactory()
        
        eventFeedbackComponentFactory = EventFeedbackComponentFactoryImpl(
            presenterFactory: eventFeedbackPresenterFactory,
            sceneFactory: eventFeedbackSceneFactory
        )
        
        webComponentFactory = SafariWebComponentFactory()
        
        additionalServicesComponentFactory = AdditionalServicesComponentBuilder(
            repository: repositories.additionalServices
        ).build()
        
        settingsComponentFactory = AppIconOnlySettingsComponentFactory(repository: dependencies.appIcons)
    }
    
}
