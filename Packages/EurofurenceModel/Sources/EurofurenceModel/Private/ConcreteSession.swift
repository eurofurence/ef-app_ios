import Foundation

class ConcreteSession: EurofurenceSession {
    
    private let eventBus = EventBus()
    
    private let sessionStateService: ConcreteSessionStateService
    private let refreshService: ConcreteRefreshService
    
    private let remoteNotificationRegistrationController: RemoteNotificationRegistrationController
    private let authenticationService: ConcreteAuthenticationService
    private let privateMessagesService: ConcretePrivateMessagesService
    private let conventionCountdownService: ConcreteConventionCountdownService
    
    private let announcementsRepository: ConcreteAnnouncementsRepository
    private let knowledgeService: ConcreteKnowledgeService
    private let scheduleRepository: ConcreteScheduleRepository
    private let dealersService: ConcreteDealersService
    private let significantTimeObserver: SignificantTimeObserver
    private let collectThemAllService: ConcreteCollectThemAllService
    private let mapsService: ConcreteMapsService
    private let notificationService: ConcreteNotificationService
    private let contentLinksService: ConcreteContentLinksService
    private let additionalServicesRepository: ConcreteAdditionalServicesRepository
    private let eventFeedbackService: EventFeedbackService
    
    // swiftlint:disable function_body_length
    init(
        conventionIdentifier: ConventionIdentifier,
        api: API,
        userPreferences: UserPreferences,
        dataStoreFactory: DataStoreFactory,
        remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?,
        clock: Clock,
        credentialRepository: CredentialRepository,
        conventionStartDateRepository: ConventionStartDateRepository,
        timeIntervalForUpcomingEventsSinceNow: TimeInterval,
        imageRepository: ImageRepository,
        significantTimeChangeAdapter: SignificantTimeChangeAdapter?,
        urlOpener: URLOpener?,
        collectThemAllRequestFactory: CollectThemAllRequestFactory,
        longRunningTaskManager: LongRunningTaskManager?,
        mapCoordinateRender: MapCoordinateRender?,
        forceRefreshRequired: ForceRefreshRequired,
        companionAppURLRequestFactory: CompanionAppURLRequestFactory,
        refreshCollaboration: RefreshCollaboration,
        shareableURLFactory: ShareableURLFactory
    ) {
        
        let dataStore = dataStoreFactory.makeDataStore(for: conventionIdentifier)
        
        remoteNotificationRegistrationController = RemoteNotificationRegistrationController(
            eventBus: eventBus,
            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration
        )
        
        privateMessagesService = ConcretePrivateMessagesService(eventBus: eventBus, api: api)
        
        additionalServicesRepository = ConcreteAdditionalServicesRepository(
            eventBus: eventBus,
            companionAppURLRequestFactory: companionAppURLRequestFactory
        )
        
        authenticationService = ConcreteAuthenticationService(
            eventBus: eventBus,
            clock: clock,
            credentialRepository: credentialRepository,
            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
            api: api
        )
        
        conventionCountdownService = ConcreteConventionCountdownService(
            eventBus: eventBus,
            conventionStartDateRepository: conventionStartDateRepository,
            clock: clock
        )
        
        announcementsRepository = ConcreteAnnouncementsRepository(
            eventBus: eventBus,
            dataStore: dataStore,
            imageRepository: imageRepository
        )
        
        knowledgeService = ConcreteKnowledgeService(
            eventBus: eventBus,
            dataStore: dataStore,
            imageRepository: imageRepository,
            shareableURLFactory: shareableURLFactory
        )
        
        let imageCache = ImagesCache(
            eventBus: eventBus,
            imageRepository: imageRepository
        )
        
        scheduleRepository = ConcreteScheduleRepository(
            eventBus: eventBus,
            dataStore: dataStore,
            imageCache: imageCache,
            clock: clock,
            timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow,
            shareableURLFactory: shareableURLFactory
        )
        
        let imageDownloader = ImageDownloader(
            eventBus: eventBus,
            api: api,
            imageRepository: imageRepository
        )
        
        significantTimeObserver = SignificantTimeObserver(
            significantTimeChangeAdapter: significantTimeChangeAdapter,
            eventBus: eventBus
        )
        
        dealersService = ConcreteDealersService(
            eventBus: eventBus,
            dataStore: dataStore,
            imageCache: imageCache,
            mapCoordinateRender: mapCoordinateRender,
            shareableURLFactory: shareableURLFactory,
            urlOpener: urlOpener
        )
        
        collectThemAllService = ConcreteCollectThemAllService(
            eventBus: eventBus,
            collectThemAllRequestFactory: collectThemAllRequestFactory,
            credentialRepository: credentialRepository
        )
        
        mapsService = ConcreteMapsService(
            eventBus: eventBus,
            dataStore: dataStore,
            imageRepository: imageRepository,
            dealers: dealersService
        )
        
        let dataStoreBridge = DataStoreSyncBridge(
            dataStore: dataStore,
            clock: clock,
            imageCache: imageCache,
            imageRepository: imageRepository,
            eventBus: eventBus
        )
        
        refreshService = ConcreteRefreshService(
            conventionIdentifier: conventionIdentifier,
            longRunningTaskManager: longRunningTaskManager,
            dataStore: dataStore,
            api: api,
            imageDownloader: imageDownloader,
            privateMessagesController: privateMessagesService,
            forceRefreshRequired: forceRefreshRequired,
            refreshCollaboration: refreshCollaboration,
            dataStoreBridge: dataStoreBridge
        )
        
        notificationService = ConcreteNotificationService(eventBus: eventBus)
        
        let urlEntityProcessor = URLEntityProcessor(
            eventsService: scheduleRepository,
            dealersService: dealersService, dataStore: dataStore
        )
        
        contentLinksService = ConcreteContentLinksService(urlEntityProcessor: urlEntityProcessor)
        
        eventFeedbackService = EventFeedbackService(api: api, eventBus: eventBus)
        
        sessionStateService = ConcreteSessionStateService(
            eventBus: eventBus,
            forceRefreshRequired: forceRefreshRequired,
            userPreferences: userPreferences,
            dataStore: dataStore
        )
        
        privateMessagesService.refreshMessages()
    }
    
    lazy var services = Services(
        notifications: notificationService,
        refresh: refreshService,
        authentication: authenticationService,
        dealers: dealersService,
        knowledge: knowledgeService,
        contentLinks: contentLinksService,
        conventionCountdown: conventionCountdownService,
        collectThemAll: collectThemAllService,
        maps: mapsService,
        sessionState: sessionStateService,
        privateMessages: privateMessagesService
    )
    
    lazy var repositories = Repositories(
        additionalServices: additionalServicesRepository,
        announcements: announcementsRepository,
        events: scheduleRepository
    )
    
}
