//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public enum LogoutResult {
    case success
    case failure
}

public enum PrivateMessageResult {
    case success([Message])
    case failedToLoad
    case userNotAuthenticated
}

// TODO: Temporarily made public to aid migration, should be internal
public class EurofurenceApplication: EurofurenceApplicationProtocol {

    public static var shared: EurofurenceApplicationProtocol = EurofurenceApplicationBuilder().build()

    private let eventBus = EventBus()
    private let userPreferences: UserPreferences
    private let dataStore: EurofurenceDataStore
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
    private let longRunningTaskManager: LongRunningTaskManager?
    private let forceRefreshRequired: ForceRefreshRequired
    private let imageRepository: ImageRepository

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
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?,
         pushPermissionsRequester: PushPermissionsRequester?,
         clock: Clock,
         credentialStore: CredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI,
         syncAPI: SyncAPI,
         imageAPI: ImageAPI,
         dateDistanceCalculator: DateDistanceCalculator,
         conventionStartDateRepository: ConventionStartDateRepository,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval,
         imageRepository: ImageRepository,
         significantTimeChangeAdapter: SignificantTimeChangeAdapter?,
         urlOpener: URLOpener?,
         collectThemAllRequestFactory: CollectThemAllRequestFactory,
         longRunningTaskManager: LongRunningTaskManager?,
         notificationsService: NotificationsService?,
         hoursDateFormatter: HoursDateFormatter,
         mapCoordinateRender: MapCoordinateRender?,
         forceRefreshRequired: ForceRefreshRequired) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.clock = clock
        self.syncAPI = syncAPI
        self.imageAPI = imageAPI
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        self.credentialStore = credentialStore
        self.longRunningTaskManager = longRunningTaskManager
        self.forceRefreshRequired = forceRefreshRequired
        self.imageRepository = imageRepository

        pushPermissionsRequester?.requestPushPermissions()

        remoteNotificationRegistrationController = RemoteNotificationRegistrationController(eventBus: eventBus,
                                                                                            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration)
        privateMessagesController = PrivateMessagesController(eventBus: eventBus, privateMessagesAPI: privateMessagesAPI)
        authenticationCoordinator = UserAuthenticationCoordinator(eventBus: eventBus,
                                                                  clock: clock,
                                                                  credentialStore: credentialStore,
                                                                  remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                                  loginAPI: loginAPI)

        conventionCountdownController = ConventionCountdownController(eventBus: eventBus,
                                                                      conventionStartDateRepository: conventionStartDateRepository,
                                                                      dateDistanceCalculator: dateDistanceCalculator,
                                                                      clock: clock)

        imageCache = ImagesCache(eventBus: eventBus, imageRepository: imageRepository)
        announcements = Announcements(eventBus: eventBus, dataStore: dataStore, imageRepository: imageRepository)
        knowledge = Knowledge(eventBus: eventBus, dataStore: dataStore, imageRepository: imageRepository)
        schedule = Schedule(eventBus: eventBus,
                            dataStore: dataStore,
                            imageCache: imageCache,
                            clock: clock,
                            timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow,
                            notificationsService: notificationsService,
                            userPreferences: userPreferences,
                            hoursDateFormatter: hoursDateFormatter)
        imageDownloader = ImageDownloader(eventBus: eventBus, imageAPI: imageAPI, imageRepository: imageRepository)
        significantTimeObserver = SignificantTimeObserver(significantTimeChangeAdapter: significantTimeChangeAdapter,
                                                          eventBus: eventBus)
        dealers = Dealers(eventBus: eventBus, dataStore: dataStore, imageCache: imageCache, mapCoordinateRender: mapCoordinateRender)
        urlHandler = URLHandler(eventBus: eventBus, urlOpener: urlOpener)
        collectThemAll = CollectThemAll(eventBus: eventBus,
                                        collectThemAllRequestFactory: collectThemAllRequestFactory,
                                        credentialStore: credentialStore)
        maps = Maps(eventBus: eventBus, dataStore: dataStore, imageRepository: imageRepository, dealers: dealers)

        fetchPrivateMessages { (_) in }
    }

    public func handleRemoteNotification(payload: [String: String], completionHandler: @escaping (ApplicationPushActionResult) -> Void) {
        if payload[ApplicationNotificationKey.notificationContentKind.rawValue] == ApplicationNotificationContentKind.event.rawValue {
            guard let identifier = payload[ApplicationNotificationKey.notificationContentIdentifier.rawValue] else {
                completionHandler(.unknown)
                return
            }

            guard schedule.eventModels.contains(where: { $0.identifier.rawValue == identifier }) else {
                completionHandler(.unknown)
                return
            }

            let action = ApplicationPushActionResult.event(Event2.Identifier(identifier))
            completionHandler(action)

            return
        }

        refreshLocalStore { (error) in
            if error == nil {
                if let announcementIdentifier = payload["announcement_id"] {
                    let identifier = Announcement.Identifier(announcementIdentifier)
                    if self.announcements.models.contains(where: { $0.identifier == identifier }) {
                        completionHandler(.announcement(identifier))
                    } else {
                        completionHandler(.invalidatedAnnouncement)
                    }
                } else {
                    completionHandler(.successfulSync)
                }
            } else {
                completionHandler(.failedSync)
            }
        }
    }

    private var refreshObservers = [RefreshServiceObserver]()
    public func add(_ observer: RefreshServiceObserver) {
        refreshObservers.append(observer)
    }

    public func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void) {
        let shouldPerformForceRefresh: Bool = forceRefreshRequired.isForceRefreshRequired
        let state: EurofurenceDataStoreState = {
            guard dataStore.getLastRefreshDate() != nil else { return .absent }

            let dataStoreStale = shouldPerformForceRefresh || userPreferences.refreshStoreOnLaunch
            return dataStoreStale ? .stale : .available
        }()

        completionHandler(state)
    }

    public func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        authenticationCoordinator.login(arguments, completionHandler: completionHandler)
    }

    public func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        authenticationCoordinator.logout(completionHandler: completionHandler)
    }

    public func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationRegistrationSucceeded(deviceToken: deviceToken))
    }

    public var localPrivateMessages: [Message] { return privateMessagesController.localPrivateMessages }

    public func add(_ observer: PrivateMessagesObserver) {
        privateMessagesController.add(observer)
    }

    public func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        privateMessagesController.fetchPrivateMessages(completionHandler: completionHandler)
    }

    public func markMessageAsRead(_ message: Message) {
        privateMessagesController.markMessageAsRead(message)
    }

    public func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        authenticationCoordinator.retrieveCurrentUser(completionHandler: completionHandler)
    }

    public func add(_ observer: KnowledgeServiceObserver) {
        knowledge.add(observer)
    }

    public func fetchKnowledgeEntry(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntry2) -> Void) {
        knowledge.fetchKnowledgeEntry(for: identifier, completionHandler: completionHandler)
    }

    public func fetchKnowledgeGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping (KnowledgeGroup2) -> Void) {
        knowledge.fetchKnowledgeGroup(identifier: identifier, completionHandler: completionHandler)
    }

    public func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping ([Data]) -> Void) {
        knowledge.fetchImagesForKnowledgeEntry(identifier: identifier, completionHandler: completionHandler)
    }

    public func add(_ observer: EventsServiceObserver) {
        schedule.add(observer)
    }

    public func favouriteEvent(identifier: Event2.Identifier) {
        schedule.favouriteEvent(identifier: identifier)
    }

    public func unfavouriteEvent(identifier: Event2.Identifier) {
        schedule.unfavouriteEvent(identifier: identifier)
    }

    public func makeEventsSchedule() -> EventsSchedule {
        return schedule.makeScheduleAdapter()
    }

    public func makeEventsSearchController() -> EventsSearchController {
        return schedule.makeEventsSearchController()
    }

    public func fetchEvent(for identifier: Event2.Identifier, completionHandler: @escaping (Event2?) -> Void) {
        schedule.fetchEvent(for: identifier, completionHandler: completionHandler)
    }

    public func makeDealersIndex() -> DealersIndex {
        return dealers.makeDealersIndex()
    }

    public func fetchIconPNGData(for identifier: Dealer.Identifier, completionHandler: @escaping (Data?) -> Void) {
        dealers.fetchIconPNGData(for: identifier, completionHandler: completionHandler)
    }

    public func fetchExtendedDealerData(for dealer: Dealer.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        dealers.fetchExtendedDealerData(for: dealer, completionHandler: completionHandler)
    }

    public func openWebsite(for identifier: Dealer.Identifier) {
        dealers.openWebsite(for: identifier)
    }

    public func openTwitter(for identifier: Dealer.Identifier) {
        dealers.openTwitter(for: identifier)
    }

    public func openTelegram(for identifier: Dealer.Identifier) {
        dealers.openTelegram(for: identifier)
    }

    public func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {
        urlHandler.externalContentHandler = externalContentHandler
    }

    public func subscribe(_ observer: CollectThemAllURLObserver) {
        collectThemAll.subscribe(observer)
    }

    public func add(_ observer: MapsObserver) {
        maps.add(observer)
    }

    public func fetchImagePNGDataForMap(identifier: Map2.Identifier, completionHandler: @escaping (Data) -> Void) {
        maps.fetchImagePNGDataForMap(identifier: identifier, completionHandler: completionHandler)
    }

    public func fetchContent(for identifier: Map2.Identifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (Map2.Content) -> Void) {
        maps.fetchContent(for: identifier, atX: x, y: y, completionHandler: completionHandler)
    }

    public func performFullStoreRefresh(completionHandler: @escaping (Error?) -> Void) -> Progress {
        return performSync(lastSyncTime: nil, completionHandler: completionHandler)
    }

    @discardableResult
    public func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        return performSync(lastSyncTime: dataStore.getLastRefreshDate(), completionHandler: completionHandler)
    }

    private func performSync(lastSyncTime: Date?, completionHandler: @escaping (Error?) -> Void) -> Progress {
        enum SyncError: Error {
            case failedToLoadResponse
        }

        refreshObservers.forEach({ $0.refreshServiceDidBeginRefreshing() })

        let longRunningTask = longRunningTaskManager?.beginLongRunningTask()
        let finishLongRunningTask: () -> Void = {
            if let taskManager = self.longRunningTaskManager, let task = longRunningTask {
                taskManager.finishLongRunningTask(token: task)
            }
        }

        let progress = Progress()
        progress.totalUnitCount = -1
        progress.completedUnitCount = -1

        let existingAnnouncements = dataStore.getSavedAnnouncements().or([])
        let existingKnowledgeGroups = dataStore.getSavedKnowledgeGroups().or([])
        let existingKnowledgeEntries = dataStore.getSavedKnowledgeEntries().or([])
        let existingEvents = dataStore.getSavedEvents().or([])
        let existingImages = dataStore.getSavedImages().or([])
        let existingDealers = dataStore.getSavedDealers().or([])
        let existingMaps = dataStore.getSavedMaps().or([])
        syncAPI.fetchLatestData(lastSyncTime: lastSyncTime) { (response) in
            guard let response = response else {
                finishLongRunningTask()

                self.refreshObservers.forEach({ $0.refreshServiceDidFinishRefreshing() })
                completionHandler(SyncError.failedToLoadResponse)
                return
            }

            self.syncResponse = response

            let imageIdentifiers = response.images.changed.map({ $0.identifier })
            progress.completedUnitCount = 0
            progress.totalUnitCount = Int64(imageIdentifiers.count)

            var imageIdentifiersToDelete: [String] = []
            if response.images.removeAllBeforeInsert {
                imageIdentifiersToDelete = existingImages.map({ $0.identifier })
                imageIdentifiersToDelete.forEach(self.imageCache.deleteImage)
            }

            self.imageDownloader.downloadImages(identifiers: imageIdentifiers, parentProgress: progress) {
                self.eventBus.post(DomainEvent.LatestDataFetchedEvent(response: response))

                self.dataStore.performTransaction({ (transaction) in
                    imageIdentifiersToDelete.forEach(transaction.deleteImage)
                    response.events.deleted.forEach(transaction.deleteEvent)
                    response.tracks.deleted.forEach(transaction.deleteTrack)
                    response.rooms.deleted.forEach(transaction.deleteRoom)
                    response.conferenceDays.deleted.forEach(transaction.deleteConferenceDay)
                    response.maps.deleted.forEach(transaction.deleteMap)
                    response.dealers.deleted.forEach(transaction.deleteDealer)
                    response.knowledgeEntries.deleted.forEach(transaction.deleteKnowledgeEntry)
                    response.knowledgeGroups.deleted.forEach(transaction.deleteKnowledgeGroup)
                    response.announcements.deleted.forEach(transaction.deleteAnnouncement)

                    if lastSyncTime == nil {
                        func not<T>(_ predicate: @escaping (T) -> Bool) -> (T) -> Bool {
                            return { (element) in return !predicate(element) }
                        }

                        let changedAnnouncementIdentifiers = response.announcements.changed.map({ $0.identifier })
                        let orphanedAnnouncements = existingAnnouncements.map({ $0.identifier }).filter(not(changedAnnouncementIdentifiers.contains))
                        orphanedAnnouncements.forEach(transaction.deleteAnnouncement)

                        let changedEventIdentifiers = response.events.changed.map({ $0.identifier })
                        let orphanedEvents = existingEvents.map({ $0.identifier }).filter(not(changedEventIdentifiers.contains))
                        orphanedEvents.forEach(transaction.deleteEvent)

                        let changedKnowledgeGroupIdentifiers = response.knowledgeGroups.changed.map({ $0.identifier })
                        let orphanedKnowledgeGroups = existingKnowledgeGroups.map({ $0.identifier }).filter(not(changedKnowledgeGroupIdentifiers.contains))
                        orphanedKnowledgeGroups.forEach(transaction.deleteKnowledgeGroup)

                        let changedKnowledgeEntryIdentifiers = response.knowledgeEntries.changed.map({ $0.identifier })
                        let orphanedKnowledgeEntries = existingKnowledgeEntries.map({ $0.identifier }).filter(not(changedKnowledgeEntryIdentifiers.contains))
                        orphanedKnowledgeEntries.forEach(transaction.deleteKnowledgeEntry)

                        let existingImageIdentifiers = existingImages.map({ $0.identifier })
                        let changedImageIdentifiers = response.images.changed.map({ $0.identifier })
                        let orphanedImages = existingImageIdentifiers.filter(not(changedImageIdentifiers.contains))
                        orphanedImages.forEach(self.imageRepository.deleteEntity)

                        let existingDealerIdentifiers = existingDealers.map({ $0.identifier })
                        let changedDealerIdentifiers = response.dealers.changed.map({ $0.identifier })
                        let orphanedDealers = existingDealerIdentifiers.filter(not(changedDealerIdentifiers.contains))
                        orphanedDealers.forEach(transaction.deleteDealer)

                        let existingMapsIdentifiers = existingMaps.map({ $0.identifier })
                        let changedMapIdentifiers = response.maps.changed.map({ $0.identifier })
                        let orphanedMaps = existingMapsIdentifiers.filter(not(changedMapIdentifiers.contains))
                        orphanedMaps.forEach(transaction.deleteMap)
                    }

                    if response.announcements.removeAllBeforeInsert {
                        self.announcements.models.map({ $0.identifier.rawValue }).forEach(transaction.deleteAnnouncement)
                    }

                    if response.conferenceDays.removeAllBeforeInsert {
                        self.schedule.days.map({ $0.identifier }).forEach(transaction.deleteConferenceDay)
                    }

                    if response.rooms.removeAllBeforeInsert {
                        self.schedule.rooms.map({ $0.roomIdentifier }).forEach(transaction.deleteRoom)
                    }

                    if response.tracks.removeAllBeforeInsert {
                        self.schedule.tracks.map({ $0.trackIdentifier }).forEach(transaction.deleteTrack)
                    }

                    if response.knowledgeGroups.removeAllBeforeInsert {
                        self.knowledge.models.map({ $0.identifier.rawValue }).forEach(transaction.deleteKnowledgeGroup)
                    }

                    if response.knowledgeEntries.removeAllBeforeInsert {
                        self.knowledge.models.reduce([], { $0 + $1.entries }).map({ $0.identifier.rawValue }).forEach(transaction.deleteKnowledgeEntry)
                    }

                    if response.dealers.removeAllBeforeInsert {
                        existingDealers.map({ $0.identifier }).forEach(transaction.deleteDealer)
                    }

                    transaction.saveEvents(response.events.changed)
                    transaction.saveRooms(response.rooms.changed)
                    transaction.saveTracks(response.tracks.changed)
                    transaction.saveConferenceDays(response.conferenceDays.changed)
                    transaction.saveMaps(response.maps.changed)
                    transaction.saveDealers(response.dealers.changed)
                    transaction.saveKnowledgeGroups(response.knowledgeGroups.changed)
                    transaction.saveKnowledgeEntries(response.knowledgeEntries.changed)
                    transaction.saveAnnouncements(response.announcements.changed)

                    transaction.saveLastRefreshDate(self.clock.currentDate)
                    transaction.saveImages(response.images.changed)
                    response.images.deleted.forEach(transaction.deleteImage)
                    response.images.deleted.forEach(self.imageCache.deleteImage)
                })

                self.eventBus.post(DomainEvent.DataStoreChangedEvent())

                self.privateMessagesController.fetchPrivateMessages { (_) in
                    completionHandler(nil)
                    self.refreshObservers.forEach({ $0.refreshServiceDidFinishRefreshing() })
                    finishLongRunningTask()
                }
            }
        }

        return progress
    }

    public func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "https" || scheme == "http" {
            return .web(url)
        }

        return .externalURL(url)
    }

    public func add(_ observer: AnnouncementsServiceObserver) {
        announcements.add(observer)
    }

    public func openAnnouncement(identifier: Announcement.Identifier, completionHandler: @escaping (Announcement) -> Void) {
        announcements.openAnnouncement(identifier: identifier, completionHandler: completionHandler)
    }

    public func fetchAnnouncementImage(identifier: Announcement.Identifier, completionHandler: @escaping (Data?) -> Void) {
        announcements.fetchAnnouncementImage(identifier: identifier, completionHandler: completionHandler)
    }

    public func add(_ observer: ConventionCountdownServiceObserver) {
        conventionCountdownController.observeDaysUntilConvention(using: observer)
    }

    public func add(_ observer: AuthenticationStateObserver) {
        authenticationCoordinator.add(observer)
    }

}
