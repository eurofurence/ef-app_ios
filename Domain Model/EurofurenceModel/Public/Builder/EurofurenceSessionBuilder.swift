import Foundation

public class EurofurenceSessionBuilder {
    
    public struct Mandatory {
        
        public var conventionIdentifier: ConventionIdentifier
        public var conventionStartDateRepository: ConventionStartDateRepository
        public var shareableURLFactory: ShareableURLFactory

        public init(conventionIdentifier: ConventionIdentifier,
                    conventionStartDateRepository: ConventionStartDateRepository,
                    shareableURLFactory: ShareableURLFactory) {
            self.conventionIdentifier = conventionIdentifier
            self.conventionStartDateRepository = conventionStartDateRepository
            self.shareableURLFactory = shareableURLFactory
        }
        
    }
    
    private let conventionIdentifier: ConventionIdentifier
    private let conventionStartDateRepository: ConventionStartDateRepository
    private let shareableURLFactory: ShareableURLFactory

    private var userPreferences: UserPreferences
    private var dataStoreFactory: DataStoreFactory
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?
    private var clock: Clock
    private var credentialStore: CredentialStore
    private var api: API
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private var imageRepository: ImageRepository
    private var significantTimeChangeAdapter: SignificantTimeChangeAdapter?
    private var urlOpener: URLOpener?
    private var collectThemAllRequestFactory: CollectThemAllRequestFactory
    private var longRunningTaskManager: LongRunningTaskManager?
    private var mapCoordinateRender: MapCoordinateRender?
    private var forceRefreshRequired: ForceRefreshRequired
    private var companionAppURLRequestFactory: CompanionAppURLRequestFactory
    private var refreshCollaboration: RefreshCollaboration = DoNothingRefreshCollaboration()

    public init(mandatory: Mandatory) {
        self.conventionIdentifier = mandatory.conventionIdentifier
        self.conventionStartDateRepository = mandatory.conventionStartDateRepository
        self.shareableURLFactory = mandatory.shareableURLFactory
        
        userPreferences = UserDefaultsPreferences()
        dataStoreFactory = CoreDataStoreFactory()

        let jsonSession = URLSessionBasedJSONSession.shared
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: conventionIdentifier)
        api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)

        clock = SystemClock.shared
        credentialStore = KeychainCredentialStore()
        timeIntervalForUpcomingEventsSinceNow = 3600
        imageRepository = PersistentImageRepository()
        collectThemAllRequestFactory = DefaultCollectThemAllRequestFactory()
        forceRefreshRequired = UserDefaultsForceRefreshRequired()
        companionAppURLRequestFactory = HardcodedCompanionAppURLRequestFactory()
    }

    @discardableResult
    public func with(_ userPreferences: UserPreferences) -> EurofurenceSessionBuilder {
        self.userPreferences = userPreferences
        return self
    }

    @discardableResult
    public func with(_ dataStoreFactory: DataStoreFactory) -> EurofurenceSessionBuilder {
        self.dataStoreFactory = dataStoreFactory
        return self
    }

    @discardableResult
    public func with(_ remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration) -> EurofurenceSessionBuilder {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        return self
    }

    @discardableResult
    public func with(_ clock: Clock) -> EurofurenceSessionBuilder {
        self.clock = clock
        return self
    }

    @discardableResult
    public func with(_ credentialStore: CredentialStore) -> EurofurenceSessionBuilder {
        self.credentialStore = credentialStore
        return self
    }

    @discardableResult
    public func with(timeIntervalForUpcomingEventsSinceNow: TimeInterval) -> EurofurenceSessionBuilder {
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        return self
    }

    @discardableResult
    public func with(_ api: API) -> EurofurenceSessionBuilder {
        self.api = api
        return self
    }

    @discardableResult
    public func with(_ imageRepository: ImageRepository) -> EurofurenceSessionBuilder {
        self.imageRepository = imageRepository
        return self
    }

    @discardableResult
    public func with(_ significantTimeChangeAdapter: SignificantTimeChangeAdapter) -> EurofurenceSessionBuilder {
        self.significantTimeChangeAdapter = significantTimeChangeAdapter
        return self
    }

    @discardableResult
    public func with(_ urlOpener: URLOpener) -> EurofurenceSessionBuilder {
        self.urlOpener = urlOpener
        return self
    }

    @discardableResult
    public func with(_ collectThemAllRequestFactory: CollectThemAllRequestFactory) -> EurofurenceSessionBuilder {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        return self
    }

    @discardableResult
    public func with(_ longRunningTaskManager: LongRunningTaskManager) -> EurofurenceSessionBuilder {
        self.longRunningTaskManager = longRunningTaskManager
        return self
    }

    @discardableResult
    public func with(_ mapCoordinateRender: MapCoordinateRender) -> EurofurenceSessionBuilder {
        self.mapCoordinateRender = mapCoordinateRender
        return self
    }

    @discardableResult
    public func with(_ forceRefreshRequired: ForceRefreshRequired) -> EurofurenceSessionBuilder {
        self.forceRefreshRequired = forceRefreshRequired
        return self
    }
    
    @discardableResult
    public func with(_ companionAppURLRequestFactory: CompanionAppURLRequestFactory) -> EurofurenceSessionBuilder {
        self.companionAppURLRequestFactory = companionAppURLRequestFactory
        return self
    }
    
    @discardableResult
    public func with(_ refreshCollaboration: RefreshCollaboration) -> EurofurenceSessionBuilder {
        self.refreshCollaboration = refreshCollaboration
        return self
    }

    public func build() -> EurofurenceSession {
        return ConcreteSession(conventionIdentifier: conventionIdentifier,
                               api: api,
                               userPreferences: userPreferences,
                               dataStoreFactory: dataStoreFactory,
                               remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                               clock: clock,
                               credentialStore: credentialStore,
                               conventionStartDateRepository: conventionStartDateRepository,
                               timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow,
                               imageRepository: imageRepository,
                               significantTimeChangeAdapter: significantTimeChangeAdapter,
                               urlOpener: urlOpener,
                               collectThemAllRequestFactory: collectThemAllRequestFactory,
                               longRunningTaskManager: longRunningTaskManager,
                               mapCoordinateRender: mapCoordinateRender,
                               forceRefreshRequired: forceRefreshRequired,
                               companionAppURLRequestFactory: companionAppURLRequestFactory,
                               refreshCollaboration: refreshCollaboration,
                               shareableURLFactory: shareableURLFactory)
    }

}
