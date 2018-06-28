//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum LogoutResult {
    case success
    case failure
}

enum PrivateMessageResult {
    case success([Message])
    case failedToLoad
    case userNotAuthenticated
}

class EurofurenceApplication: EurofurenceApplicationProtocol {

    static var shared: EurofurenceApplicationProtocol = EurofurenceApplicationBuilder().build()

    private let eventBus = EventBus()
    private let userPreferences: UserPreferences
    private let dataStore: EurofurenceDataStore
    private let pushPermissionsRequester: PushPermissionsRequester
    private let pushPermissionsStateProviding: PushPermissionsStateProviding
    private let clock: Clock
    private let remoteNotificationRegistrationController: RemoteNotificationRegistrationController
    private let authenticationCoordinator: UserAuthenticationCoordinator
    private let privateMessagesController: PrivateMessagesController
    private let syncAPI: SyncAPI
    private let imageAPI: ImageAPI
    private let conventionCountdownController: ConventionCountdownController
    private var syncResponse: APISyncResponse?
    private var events = [Event2]()
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private let collectThemAllRequestFactory: CollectThemAllRequestFactory
    private let credentialStore: CredentialStore

    private let imageCache: ImagesCache
    private let imageDownloader: ImageDownloader
    private let announcements: Announcements
    private let knowledge: Knowledge
    private let schedule: Schedule
    private let dealers: Dealers
    private let significantTimeObserver: SignificantTimeObserver
    private let urlHandler: URLHandler
    private let collectThemAll: CollectThemAll
    private let maps: Maps

    init(userPreferences: UserPreferences,
         dataStore: EurofurenceDataStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         pushPermissionsRequester: PushPermissionsRequester,
         pushPermissionsStateProviding: PushPermissionsStateProviding,
         clock: Clock,
         credentialStore: CredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI,
         syncAPI: SyncAPI,
         imageAPI: ImageAPI,
         dateDistanceCalculator: DateDistanceCalculator,
         conventionStartDateRepository: ConventionStartDateRepository,
         significantTimeChangeEventSource: SignificantTimeChangeEventSource,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval,
         imageRepository: ImageRepository,
         significantTimeChangeAdapter: SignificantTimeChangeAdapter,
         urlOpener: URLOpener,
         collectThemAllRequestFactory: CollectThemAllRequestFactory) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
        self.clock = clock
        self.syncAPI = syncAPI
        self.imageAPI = imageAPI
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        self.credentialStore = credentialStore

        if pushPermissionsStateProviding.requestedPushNotificationAuthorization {
            pushPermissionsRequester.requestPushPermissions()
        }

        remoteNotificationRegistrationController = RemoteNotificationRegistrationController(eventBus: eventBus,
                                                                                            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration)
        privateMessagesController = PrivateMessagesController(eventBus: eventBus, privateMessagesAPI: privateMessagesAPI)
        authenticationCoordinator = UserAuthenticationCoordinator(eventBus: eventBus,
                                                                  clock: clock,
                                                                  credentialStore: credentialStore,
                                                                  remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                                  loginAPI: loginAPI)

        conventionCountdownController = ConventionCountdownController(significantTimeChangeEventSource: significantTimeChangeEventSource,
                                                                      conventionStartDateRepository: conventionStartDateRepository,
                                                                      dateDistanceCalculator: dateDistanceCalculator,
                                                                      clock: clock)

        imageCache = ImagesCache(eventBus: eventBus, imageRepository: imageRepository)
        announcements = Announcements(eventBus: eventBus, dataStore: dataStore)
        knowledge = Knowledge(eventBus: eventBus, dataStore: dataStore)
        schedule = Schedule(eventBus: eventBus, dataStore: dataStore, imageCache: imageCache, clock: clock, timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
        imageDownloader = ImageDownloader(eventBus: eventBus, imageAPI: imageAPI)
        significantTimeObserver = SignificantTimeObserver(significantTimeChangeAdapter: significantTimeChangeAdapter,
                                                          eventBus: eventBus)
        dealers = Dealers(eventBus: eventBus, dataStore: dataStore, imageCache: imageCache)
        urlHandler = URLHandler(eventBus: eventBus, urlOpener: urlOpener)
        collectThemAll = CollectThemAll(eventBus: eventBus,
                                        collectThemAllRequestFactory: collectThemAllRequestFactory,
                                        credentialStore: credentialStore)
        maps = Maps(eventBus: eventBus, dataStore: dataStore, imageRepository: imageRepository)
    }

    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void) {
        if dataStore.getLastRefreshDate() == nil {
            completionHandler(.absent)
        } else {
            if userPreferences.refreshStoreOnLaunch {
                completionHandler(.stale)
            } else {
                completionHandler(.available)
            }
        }
    }

    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        authenticationCoordinator.login(arguments, completionHandler: completionHandler)
    }

    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        authenticationCoordinator.logout(completionHandler: completionHandler)
    }

    func requestPermissionsForPushNotifications() {
        pushPermissionsRequester.requestPushPermissions()
        pushPermissionsStateProviding.attemptedPushAuthorizationRequest()
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationRegistrationSucceeded(deviceToken: deviceToken))
    }

    var localPrivateMessages: [Message] { return privateMessagesController.localPrivateMessages }

    func add(_ observer: PrivateMessagesObserver) {
        privateMessagesController.add(observer)
    }

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        privateMessagesController.fetchPrivateMessages(completionHandler: completionHandler)
    }

    func markMessageAsRead(_ message: Message) {
        privateMessagesController.markMessageAsRead(message)
    }

    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        authenticationCoordinator.retrieveCurrentUser(completionHandler: completionHandler)
    }

    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        knowledge.fetchKnowledgeGroups(completionHandler: completionHandler)
    }

    func add(_ observer: EventsServiceObserver) {
        schedule.add(observer)
    }

    func favouriteEvent(identifier: Event2.Identifier) {
        schedule.favouriteEvent(identifier: identifier)
    }

    func unfavouriteEvent(identifier: Event2.Identifier) {
        schedule.unfavouriteEvent(identifier: identifier)
    }

    func makeEventsSchedule() -> EventsSchedule {
        return schedule.makeScheduleAdapter()
    }

    func makeEventsSearchController() -> EventsSearchController {
        return schedule.makeEventsSearchController()
    }

    func fetchEvent(for identifier: Event2.Identifier, completionHandler: @escaping (Event2?) -> Void) {
        schedule.fetchEvent(for: identifier, completionHandler: completionHandler)
    }

    func makeDealersIndex() -> DealersIndex {
        return dealers.makeDealersIndex()
    }

    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void) {
        dealers.fetchIconPNGData(for: identifier, completionHandler: completionHandler)
    }

    func fetchExtendedDealerData(for dealer: Dealer2.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        dealers.fetchExtendedDealerData(for: dealer, completionHandler: completionHandler)
    }

    func openWebsite(for identifier: Dealer2.Identifier) {
        dealers.openWebsite(for: identifier)
    }

    func openTwitter(for identifier: Dealer2.Identifier) {
        dealers.openTwitter(for: identifier)
    }

    func openTelegram(for identifier: Dealer2.Identifier) {
        dealers.openTelegram(for: identifier)
    }

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {
        urlHandler.externalContentHandler = externalContentHandler
    }

    func subscribe(_ observer: CollectThemAllURLObserver) {
        collectThemAll.subscribe(observer)
    }

    func add(_ observer: MapsObserver) {
        maps.add(observer)
    }

    func fetchImagePNGDataForMap(identifier: Map2.Identifier, completionHandler: @escaping (Data) -> Void) {
        maps.fetchImagePNGDataForMap(identifier: identifier, completionHandler: completionHandler)
    }

    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        enum SyncError: Error {
            case failedToLoadResponse
        }

        let progress = Progress()

        let lastSyncTime = dataStore.getLastRefreshDate()
        syncAPI.fetchLatestData(lastSyncTime: lastSyncTime) { (response) in
            guard let response = response else {
                completionHandler(SyncError.failedToLoadResponse)
                return
            }

            self.syncResponse = response

            let posterImageIdentifiers = response.events.changed.map({ $0.posterImageId })
            let bannerImageIdentifiers = response.events.changed.map({ $0.bannerImageId })
            let artistThumbnailImageIdentifiers = response.dealers.changed.map({ $0.artistThumbnailImageId })
            let artistImageIdentifiers = response.dealers.changed.map({ $0.artistImageId })
            let artistPreviewImageIdentifiers = response.dealers.changed.map({ $0.artPreviewImageId })
            let mapImageIdentifiers = response.maps.changed.map({ $0.imageIdentifier })
            var imageIdentifiers: [String?] = []
            imageIdentifiers.append(contentsOf: posterImageIdentifiers)
            imageIdentifiers.append(contentsOf: bannerImageIdentifiers)
            imageIdentifiers.append(contentsOf: artistThumbnailImageIdentifiers)
            imageIdentifiers.append(contentsOf: artistImageIdentifiers)
            imageIdentifiers.append(contentsOf: artistPreviewImageIdentifiers)
            imageIdentifiers.append(contentsOf: mapImageIdentifiers)
            let nonOptionalImageIdentifiers = imageIdentifiers.compactMap({ $0 })
            progress.totalUnitCount = Int64(imageIdentifiers.count)

            self.imageDownloader.downloadImages(identifiers: nonOptionalImageIdentifiers, parentProgress: progress) {
                self.eventBus.post(DomainEvent.LatestDataFetchedEvent(response: response))

                self.dataStore.performTransaction({ (transaction) in
                    transaction.saveKnowledgeGroups(response.knowledgeGroups.changed)
                    transaction.saveKnowledgeEntries(response.knowledgeEntries.changed)
                    transaction.saveAnnouncements(response.announcements.changed)
                    transaction.saveEvents(response.events.changed)
                    transaction.saveRooms(response.rooms.changed)
                    transaction.saveTracks(response.tracks.changed)
                    transaction.saveConferenceDays(response.conferenceDays.changed)
                    transaction.saveDealers(response.dealers.changed)
                    transaction.saveMaps(response.maps.changed)
                    transaction.saveLastRefreshDate(self.clock.currentDate)
                })

                self.privateMessagesController.fetchPrivateMessages { (_) in completionHandler(nil) }
            }
        }

        return progress
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "mailto" {
            return .externalURL(url)
        }

        return .web(url)
    }

    func add(_ observer: AnnouncementsServiceObserver) {
        announcements.add(observer)
    }

    func add(_ observer: ConventionCountdownServiceObserver) {
        conventionCountdownController.observeDaysUntilConvention(using: observer)
    }

    func add(_ observer: AuthenticationStateObserver) {
        authenticationCoordinator.add(observer)
    }

}
