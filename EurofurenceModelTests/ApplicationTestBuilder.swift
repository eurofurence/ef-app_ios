//
//  ApplicationTestBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class ApplicationTestBuilder {

    struct Context {
        var application: EurofurenceSession
        var clock: StubClock
        var capturingTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var capturingCredentialStore: CapturingCredentialStore
        var loginAPI: FakeAPI
        var privateMessagesAPI: FakeAPI
        var syncAPI: FakeAPI
        var dataStore: CapturingEurofurenceDataStore
        var dateDistanceCalculator: StubDateDistanceCalculator
        var conventionStartDateRepository: StubConventionStartDateRepository
        var imageAPI: FakeAPI
        var imageRepository: CapturingImageRepository
        var significantTimeChangeAdapter: CapturingSignificantTimeChangeAdapter
        var urlOpener: CapturingURLOpener
        var longRunningTaskManager: FakeLongRunningTaskManager
        var notificationScheduler: CapturingNotificationScheduler
        var hoursDateFormatter: FakeHoursDateFormatter
        var mapCoordinateRender: CapturingMapCoordinateRender

        var services: Services {
            return application.services
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
            return capturingCredentialStore.persistedCredential?.authenticationToken
        }

        func tickTime(to time: Date) {
            clock.tickTime(to: time)
        }

        func registerForRemoteNotifications(_ deviceToken: Data = Data()) {
            notificationsService.storeRemoteNotificationsToken(deviceToken)
        }

        func login(registrationNumber: Int = 0,
                   username: String = "",
                   password: String = "",
                   completionHandler: @escaping (LoginResult) -> Void = { _ in }) {
            let arguments = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            authenticationService.login(arguments, completionHandler: completionHandler)
        }

        func loginSuccessfully() {
            login()
            loginAPI.simulateLoginResponse(LoginResponse(userIdentifier: .random, username: .random, token: .random, tokenValidUntil: Date(timeIntervalSinceNow: 1)))
        }

        @discardableResult
        func refreshLocalStore(completionHandler: ((Error?) -> Void)? = nil) -> Progress {
            return application.services.refresh.refreshLocalStore { (error) in
                completionHandler?(error)
            }
        }

        func performSuccessfulSync(response: ModelCharacteristics) {
            refreshLocalStore()
            syncAPI.simulateSuccessfulSync(response)
        }

        func simulateSignificantTimeChange() {
            significantTimeChangeAdapter.simulateSignificantTimeChange()
        }

    }

    init() {
        imageAPI = loginAPI
        privateMessagesAPI = imageAPI
        syncAPI = imageAPI
    }

    private var loginAPI = FakeAPI()
    private var imageAPI: FakeAPI
    private var privateMessagesAPI: FakeAPI
    private var syncAPI: FakeAPI

    private let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var capturingCredentialStore = CapturingCredentialStore()
    private var stubClock = StubClock()
    private var pushPermissionsRequester: PushPermissionsRequester = CapturingPushPermissionsRequester()
    private var dataStore = CapturingEurofurenceDataStore()
    private var userPreferences: UserPreferences = StubUserPreferences()
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval = .greatestFiniteMagnitude
    private var imageRepository = CapturingImageRepository()
    private var urlOpener: CapturingURLOpener = CapturingURLOpener()
    private var collectThemAllRequestFactory: CollectThemAllRequestFactory = StubCollectThemAllRequestFactory()
    private var forceUpgradeRequired: ForceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: false)

    func with(_ currentDate: Date) -> ApplicationTestBuilder {
        stubClock = StubClock(currentDate: currentDate)
        return self
    }

    func with(_ persistedCredential: Credential?) -> ApplicationTestBuilder {
        capturingCredentialStore = CapturingCredentialStore(persistedCredential: persistedCredential)
        return self
    }

    func with(_ pushPermissionsRequester: PushPermissionsRequester) -> ApplicationTestBuilder {
        self.pushPermissionsRequester = pushPermissionsRequester
        return self
    }

    @discardableResult
    func with(_ dataStore: CapturingEurofurenceDataStore) -> ApplicationTestBuilder {
        self.dataStore = dataStore
        return self
    }

    @discardableResult
    func with(_ userPreferences: UserPreferences) -> ApplicationTestBuilder {
        self.userPreferences = userPreferences
        return self
    }

    @discardableResult
    func with(timeIntervalForUpcomingEventsSinceNow: TimeInterval) -> ApplicationTestBuilder {
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        return self
    }

    @discardableResult
    func with(_ api: FakeAPI) -> ApplicationTestBuilder {
        self.imageAPI = api
        self.loginAPI = api
        self.syncAPI = api
        self.privateMessagesAPI = api

        return self
    }

    @discardableResult
    func with(_ imageRepository: CapturingImageRepository) -> ApplicationTestBuilder {
        self.imageRepository = imageRepository
        return self
    }

    @discardableResult
    func with(_ urlOpener: CapturingURLOpener) -> ApplicationTestBuilder {
        self.urlOpener = urlOpener
        return self
    }

    @discardableResult
    func with(_ collectThemAllRequestFactory: CollectThemAllRequestFactory) -> ApplicationTestBuilder {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        return self
    }

    func loggedInWithValidCredential() -> ApplicationTestBuilder {
        let credential = Credential(username: "User",
                                    registrationNumber: 42,
                                    authenticationToken: "Token",
                                    tokenExpiryDate: .distantFuture)
        return with(credential)
    }

    @discardableResult
    func with(_ forceUpgradeRequired: ForceRefreshRequired) -> ApplicationTestBuilder {
        self.forceUpgradeRequired = forceUpgradeRequired
        return self
    }

    @discardableResult
    func build() -> Context {
        let dateDistanceCalculator = StubDateDistanceCalculator()
        let conventionStartDateRepository = StubConventionStartDateRepository()
        let significantTimeChangeAdapter = CapturingSignificantTimeChangeAdapter()
        let longRunningTaskManager = FakeLongRunningTaskManager()
        let notificationsService = CapturingNotificationScheduler()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let mapCoordinateRender = CapturingMapCoordinateRender()
        let app = EurofurenceSessionBuilder()
            .with(stubClock)
            .with(capturingCredentialStore)
            .with(dataStore)
            .with(loginAPI)
            .with(privateMessagesAPI)
            .with(pushPermissionsRequester)
            .with(capturingTokenRegistration)
            .with(userPreferences)
            .with(syncAPI)
            .with(dateDistanceCalculator)
            .with(conventionStartDateRepository)
            .with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
            .with(imageAPI)
            .with(imageRepository)
            .with(significantTimeChangeAdapter)
            .with(urlOpener)
            .with(collectThemAllRequestFactory)
            .with(longRunningTaskManager)
            .with(notificationsService)
            .with(hoursDateFormatter)
            .with(mapCoordinateRender)
            .with(forceUpgradeRequired)
            .build()

        return Context(application: app,
                       clock: stubClock,
                       capturingTokenRegistration: capturingTokenRegistration,
                       capturingCredentialStore: capturingCredentialStore,
                       loginAPI: loginAPI,
                       privateMessagesAPI: privateMessagesAPI,
                       syncAPI: syncAPI,
                       dataStore: dataStore,
                       dateDistanceCalculator: dateDistanceCalculator,
                       conventionStartDateRepository: conventionStartDateRepository,
                       imageAPI: imageAPI,
                       imageRepository: imageRepository,
                       significantTimeChangeAdapter: significantTimeChangeAdapter,
                       urlOpener: urlOpener,
                       longRunningTaskManager: longRunningTaskManager,
                       notificationScheduler: notificationsService,
                       hoursDateFormatter: hoursDateFormatter,
                       mapCoordinateRender: mapCoordinateRender)
    }

}
