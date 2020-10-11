import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class EurofurenceSessionTestBuilder {

    class Context {
        var session: EurofurenceSession
        var clock: StubClock
        var notificationTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var credentialStore: CapturingCredentialStore
        var api: FakeAPI
        var dataStore: InMemoryDataStore
        var conventionStartDateRepository: StubConventionStartDateRepository
        var imageRepository: CapturingImageRepository
        var significantTimeChangeAdapter: CapturingSignificantTimeChangeAdapter
        var urlOpener: CapturingURLOpener
        var longRunningTaskManager: FakeLongRunningTaskManager
        var mapCoordinateRender: CapturingMapCoordinateRender
        var refreshObserver: CapturingRefreshServiceObserver
        
        private(set) var lastRefreshError: RefreshServiceError?

        fileprivate init(session: EurofurenceSession,
                         clock: StubClock,
                         notificationTokenRegistration: CapturingRemoteNotificationsTokenRegistration,
                         credentialStore: CapturingCredentialStore,
                         api: FakeAPI,
                         dataStore: InMemoryDataStore,
                         conventionStartDateRepository: StubConventionStartDateRepository,
                         imageRepository: CapturingImageRepository,
                         significantTimeChangeAdapter: CapturingSignificantTimeChangeAdapter,
                         urlOpener: CapturingURLOpener,
                         longRunningTaskManager: FakeLongRunningTaskManager,
                         mapCoordinateRender: CapturingMapCoordinateRender,
                         refreshObserver: CapturingRefreshServiceObserver) {
            self.session = session
            self.clock = clock
            self.notificationTokenRegistration = notificationTokenRegistration
            self.credentialStore = credentialStore
            self.api = api
            self.dataStore = dataStore
            self.conventionStartDateRepository = conventionStartDateRepository
            self.imageRepository = imageRepository
            self.significantTimeChangeAdapter = significantTimeChangeAdapter
            self.urlOpener = urlOpener
            self.longRunningTaskManager = longRunningTaskManager
            self.mapCoordinateRender = mapCoordinateRender
            self.refreshObserver = refreshObserver
        }

        var services: Services {
            return session.services
        }
        
        var additionalServicesRepository: AdditionalServicesRepository {
            return session.repositories.additionalServices
        }

        var notificationsService: NotificationService {
            return services.notifications
        }

        var refreshService: RefreshService {
            return services.refresh
        }

        var announcementsService: AnnouncementsService {
            return services.announcements
        }

        var authenticationService: AuthenticationService {
            return services.authentication
        }

        var eventsService: EventsService {
            return services.events
        }

        var dealersService: DealersService {
            return services.dealers
        }

        var knowledgeService: KnowledgeService {
            return services.knowledge
        }

        var contentLinksService: ContentLinksService {
            return services.contentLinks
        }

        var conventionCountdownService: ConventionCountdownService {
            return services.conventionCountdown
        }

        var collectThemAllService: CollectThemAllService {
            return services.collectThemAll
        }

        var mapsService: MapsService {
            return services.maps
        }

        var sessionStateService: SessionStateService {
            return services.sessionState
        }

        var privateMessagesService: PrivateMessagesService {
            return services.privateMessages
        }

        var authenticationToken: String? {
            return credentialStore.persistedCredential?.authenticationToken
        }

        func tickTime(to time: Date) {
            clock.tickTime(to: time)
        }

        func registerForRemoteNotifications(_ deviceToken: Data = Data()) {
            notificationsService.storeRemoteNotificationsToken(deviceToken)
        }
        
        func login(
            registrationNumber: Int = 0,
            username: String = "",
            password: String = "",
            completionHandler: @escaping (LoginResult) -> Void = { _ in }
        ) {
            let arguments = LoginArguments(
                registrationNumber: registrationNumber,
                username: username,
                password: password
            )
            
            authenticationService.login(arguments, completionHandler: completionHandler)
        }
        
        func loginSuccessfully() {
            login()
            api.simulateLoginResponse(
                LoginResponse(
                    userIdentifier: .random,
                    username: .random,
                    token: .random,
                    tokenValidUntil: Date(timeIntervalSinceNow: 1)
                )
            )
        }
        
        func logoutSuccessfully() {
            authenticationService.logout(completionHandler: { (_) in })
            notificationTokenRegistration.succeedLastRequest()
        }

        @discardableResult
        func refreshLocalStore(completionHandler: ((RefreshServiceError?) -> Void)? = nil) -> Progress {
            return session.services.refresh.refreshLocalStore { (error) in
                self.lastRefreshError = error
                completionHandler?(error)
            }
        }
        
        func performSuccessfulSync(response: ModelCharacteristics) {
            refreshLocalStore()
            simulateSyncSuccess(response)
        }
        
        func simulateSyncSuccess(_ response: ModelCharacteristics) {
            api.simulateSuccessfulSync(response)
        }
        
        func simulateSyncAPIError() {
            api.simulateUnsuccessfulSync()
        }

        func simulateSignificantTimeChange() {
            significantTimeChangeAdapter.simulateSignificantTimeChange()
        }

    }

    private var api = FakeAPI()
    private var credentialStore = CapturingCredentialStore()
    private var clock = StubClock()
    private var dataStore = InMemoryDataStore()
    private var userPreferences: UserPreferences = StubUserPreferences()
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval = .greatestFiniteMagnitude
    private var imageRepository = CapturingImageRepository()
    private var urlOpener: CapturingURLOpener = CapturingURLOpener()
    private var collectThemAllRequestFactory: CollectThemAllRequestFactory = StubCollectThemAllRequestFactory()
    private var companionAppURLRequestFactory: CompanionAppURLRequestFactory = StubCompanionAppURLRequestFactory()
    private var forceUpgradeRequired: ForceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: false)
    private var longRunningTaskManager: FakeLongRunningTaskManager = FakeLongRunningTaskManager()
    private var conventionStartDateRepository = StubConventionStartDateRepository()
    private var refreshCollaboration: RefreshCollaboration?

    func with(_ currentDate: Date) -> EurofurenceSessionTestBuilder {
        clock = StubClock(currentDate: currentDate)
        return self
    }

    func with(_ persistedCredential: Credential?) -> EurofurenceSessionTestBuilder {
        credentialStore = CapturingCredentialStore(persistedCredential: persistedCredential)
        return self
    }

    @discardableResult
    func with(_ dataStore: InMemoryDataStore) -> EurofurenceSessionTestBuilder {
        self.dataStore = dataStore
        return self
    }

    @discardableResult
    func with(_ userPreferences: UserPreferences) -> EurofurenceSessionTestBuilder {
        self.userPreferences = userPreferences
        return self
    }

    @discardableResult
    func with(timeIntervalForUpcomingEventsSinceNow: TimeInterval) -> EurofurenceSessionTestBuilder {
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        return self
    }

    @discardableResult
    func with(_ api: FakeAPI) -> EurofurenceSessionTestBuilder {
        self.api = api
        return self
    }

    @discardableResult
    func with(_ imageRepository: CapturingImageRepository) -> EurofurenceSessionTestBuilder {
        self.imageRepository = imageRepository
        return self
    }

    @discardableResult
    func with(_ urlOpener: CapturingURLOpener) -> EurofurenceSessionTestBuilder {
        self.urlOpener = urlOpener
        return self
    }

    @discardableResult
    func with(_ collectThemAllRequestFactory: CollectThemAllRequestFactory) -> EurofurenceSessionTestBuilder {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        return self
    }
    
    @discardableResult
    func with(_ companionAppURLRequestFactory: CompanionAppURLRequestFactory) -> EurofurenceSessionTestBuilder {
        self.companionAppURLRequestFactory = companionAppURLRequestFactory
        return self
    }
    
    @discardableResult
    func with(_ longRunningTaskManager: FakeLongRunningTaskManager) -> EurofurenceSessionTestBuilder {
        self.longRunningTaskManager = longRunningTaskManager
        return self
    }

    func loggedInWithValidCredential() -> EurofurenceSessionTestBuilder {
        let credential = Credential(username: "User",
                                    registrationNumber: 42,
                                    authenticationToken: "Token",
                                    tokenExpiryDate: .distantFuture)
        return with(credential)
    }

    @discardableResult
    func with(_ forceUpgradeRequired: ForceRefreshRequired) -> EurofurenceSessionTestBuilder {
        self.forceUpgradeRequired = forceUpgradeRequired
        return self
    }
    
    @discardableResult
    func with(_ conventionStartDateRepository: StubConventionStartDateRepository) -> EurofurenceSessionTestBuilder {
        self.conventionStartDateRepository = conventionStartDateRepository
        return self
    }
    
    @discardableResult
    func with(_ refreshCollaboration: RefreshCollaboration) -> EurofurenceSessionTestBuilder {
        self.refreshCollaboration = refreshCollaboration
        return self
    }
    
    @discardableResult
    func build() -> Context {
        let notificationTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let significantTimeChangeAdapter = CapturingSignificantTimeChangeAdapter()
        let mapCoordinateRender = CapturingMapCoordinateRender()
        
        let builder = makeSessionBuilder()
            .with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
            .with(significantTimeChangeAdapter)
            .with(mapCoordinateRender)
            .with(notificationTokenRegistration)
        
        includeRefreshCollaboration(builder)
        
        let session = builder.build()
        
        let refreshObserver = CapturingRefreshServiceObserver()
        session.services.refresh.add(refreshObserver)

        return Context(session: session,
                       clock: clock,
                       notificationTokenRegistration: notificationTokenRegistration,
                       credentialStore: credentialStore,
                       api: api,
                       dataStore: dataStore,
                       conventionStartDateRepository: conventionStartDateRepository,
                       imageRepository: imageRepository,
                       significantTimeChangeAdapter: significantTimeChangeAdapter,
                       urlOpener: urlOpener,
                       longRunningTaskManager: longRunningTaskManager,
                       mapCoordinateRender: mapCoordinateRender,
                       refreshObserver: refreshObserver)
    }
    
    private func makeSessionBuilder() -> EurofurenceSessionBuilder {
        let conventionIdentifier = ConventionIdentifier(identifier: ModelCharacteristics.testConventionIdentifier)
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: conventionIdentifier,
            conventionStartDateRepository: conventionStartDateRepository,
            shareableURLFactory: FakeShareableURLFactory()
        )
        
        return EurofurenceSessionBuilder(mandatory: mandatory)
            .with(api)
            .with(clock)
            .with(credentialStore)
            .with(StubDataStoreFactory(conventionIdentifier: conventionIdentifier, dataStore: dataStore))
            .with(userPreferences)
            .with(imageRepository)
            .with(urlOpener)
            .with(collectThemAllRequestFactory)
            .with(longRunningTaskManager)
            .with(forceUpgradeRequired)
            .with(companionAppURLRequestFactory)
    }
    
    private func includeRefreshCollaboration(_ builder: EurofurenceSessionBuilder) {
        if let refreshCollaboration = refreshCollaboration {
            builder.with(refreshCollaboration)
        }
    }

}
