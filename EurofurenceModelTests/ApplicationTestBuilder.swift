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
        var session: EurofurenceSession
        var clock: StubClock
        var notificationTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var credentialStore: CapturingCredentialStore
        var api: FakeAPI
        var dataStore: FakeDataStore
        var dateDistanceCalculator: StubDateDistanceCalculator
        var conventionStartDateRepository: StubConventionStartDateRepository
        var imageRepository: CapturingImageRepository
        var significantTimeChangeAdapter: CapturingSignificantTimeChangeAdapter
        var urlOpener: CapturingURLOpener
        var longRunningTaskManager: FakeLongRunningTaskManager
        var notificationScheduler: CapturingNotificationScheduler
        var hoursDateFormatter: FakeHoursDateFormatter
        var mapCoordinateRender: CapturingMapCoordinateRender

        var services: Services {
            return session.services
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

        func login(registrationNumber: Int = 0,
                   username: String = "",
                   password: String = "",
                   completionHandler: @escaping (LoginResult) -> Void = { _ in }) {
            let arguments = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            authenticationService.login(arguments, completionHandler: completionHandler)
        }

        func loginSuccessfully() {
            login()
            api.simulateLoginResponse(LoginResponse(userIdentifier: .random, username: .random, token: .random, tokenValidUntil: Date(timeIntervalSinceNow: 1)))
        }

        @discardableResult
        func refreshLocalStore(completionHandler: ((Error?) -> Void)? = nil) -> Progress {
            return session.services.refresh.refreshLocalStore { (error) in
                completionHandler?(error)
            }
        }

        func performSuccessfulSync(response: ModelCharacteristics) {
            refreshLocalStore()
            api.simulateSuccessfulSync(response)
        }

        func simulateSignificantTimeChange() {
            significantTimeChangeAdapter.simulateSignificantTimeChange()
        }

    }

    private var api = FakeAPI()
    private let notificationTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var credentialStore = CapturingCredentialStore()
    private var clock = StubClock()
    private var pushPermissionsRequester: PushPermissionsRequester = CapturingPushPermissionsRequester()
    private var dataStore = FakeDataStore()
    private var userPreferences: UserPreferences = StubUserPreferences()
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval = .greatestFiniteMagnitude
    private var imageRepository = CapturingImageRepository()
    private var urlOpener: CapturingURLOpener = CapturingURLOpener()
    private var collectThemAllRequestFactory: CollectThemAllRequestFactory = StubCollectThemAllRequestFactory()
    private var forceUpgradeRequired: ForceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: false)

    private let dateDistanceCalculator = StubDateDistanceCalculator()
    private let conventionStartDateRepository = StubConventionStartDateRepository()
    private let significantTimeChangeAdapter = CapturingSignificantTimeChangeAdapter()
    private let longRunningTaskManager = FakeLongRunningTaskManager()
    private let notificationsService = CapturingNotificationScheduler()
    private let hoursDateFormatter = FakeHoursDateFormatter()
    private let mapCoordinateRender = CapturingMapCoordinateRender()

    func with(_ currentDate: Date) -> ApplicationTestBuilder {
        clock = StubClock(currentDate: currentDate)
        return self
    }

    func with(_ persistedCredential: Credential?) -> ApplicationTestBuilder {
        credentialStore = CapturingCredentialStore(persistedCredential: persistedCredential)
        return self
    }

    func with(_ pushPermissionsRequester: PushPermissionsRequester) -> ApplicationTestBuilder {
        self.pushPermissionsRequester = pushPermissionsRequester
        return self
    }

    @discardableResult
    func with(_ dataStore: FakeDataStore) -> ApplicationTestBuilder {
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
        self.api = api
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
        let app = EurofurenceSessionBuilder()
            .with(api)
            .with(clock)
            .with(credentialStore)
            .with(StubDataStoreFactory(dataStore: dataStore))
            .with(pushPermissionsRequester)
            .with(notificationTokenRegistration)
            .with(userPreferences)
            .with(dateDistanceCalculator)
            .with(conventionStartDateRepository)
            .with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
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

        return Context(session: app,
                       clock: clock,
                       notificationTokenRegistration: notificationTokenRegistration,
                       credentialStore: credentialStore,
                       api: api,
                       dataStore: dataStore,
                       dateDistanceCalculator: dateDistanceCalculator,
                       conventionStartDateRepository: conventionStartDateRepository,
                       imageRepository: imageRepository,
                       significantTimeChangeAdapter: significantTimeChangeAdapter,
                       urlOpener: urlOpener,
                       longRunningTaskManager: longRunningTaskManager,
                       notificationScheduler: notificationsService,
                       hoursDateFormatter: hoursDateFormatter,
                       mapCoordinateRender: mapCoordinateRender)
    }

}
