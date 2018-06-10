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
    private let imageCache: ImagesCache
    private let announcements: Announcements
    private let knowledge: Knowledge

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
         imageRepository: ImageRepository) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
        self.clock = clock
        self.syncAPI = syncAPI
        self.imageAPI = imageAPI
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow

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

        reconstituteEventsFromDataStore()
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

    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        enum SyncError: Error {
            case failedToLoadResponse
        }

        let progress = Progress()

        syncAPI.fetchLatestData { (response) in
            if let response = response {
                self.syncResponse = response

                self.eventBus.post(DomainEvent.LatestDataFetchedEvent(response: response))

                let posterImageIdentifiers = response.events.changed.map({ $0.posterImageId })
                let bannerImageIdentifiers = response.events.changed.map({ $0.bannerImageId })
                let imageIdentifiers = (posterImageIdentifiers + bannerImageIdentifiers).flatMap({ $0 })
                progress.totalUnitCount = Int64(imageIdentifiers.count)

                let completeSync: () -> Void = {
                    self.imageCache.save()

                    self.updateEvents(from: response)
                    self.dataStore.performTransaction({ (transaction) in
                        transaction.saveKnowledgeGroups(response.knowledgeGroups.changed)
                        transaction.saveKnowledgeEntries(response.knowledgeEntries.changed)
                        transaction.saveAnnouncements(response.announcements.changed)
                        transaction.saveEvents(response.events.changed)
                        transaction.saveRooms(response.rooms.changed)
                        transaction.saveTracks(response.tracks.changed)
                        transaction.saveLastRefreshDate(self.clock.currentDate)
                    })

                    let runningEvents = self.makeRunningEvents()
                    let upcomingEvents = self.makeUpcomingEvents()
                    self.eventsObservers.forEach({ (observer) in
                        observer.eurofurenceApplicationDidUpdateRunningEvents(to: runningEvents)
                        observer.eurofurenceApplicationDidUpdateUpcomingEvents(to: upcomingEvents)
                    })

                    self.privateMessagesController.fetchPrivateMessages { (_) in completionHandler(nil) }
                }

                if imageIdentifiers.isEmpty {
                    completeSync()
                } else {
                    var pendingImageIdentifiers = imageIdentifiers
                    imageIdentifiers.forEach({ (posterID) in
                        self.imageAPI.fetchImage(identifier: posterID, completionHandler: { (posterData) in
                            guard let idx = pendingImageIdentifiers.index(of: posterID) else { return }
                            pendingImageIdentifiers.remove(at: idx)

                            if let data = posterData {
                                let event = ImageDownloadedEvent(identifier: posterID, pngImageData: data)
                                self.eventBus.post(event)
                            }

                            var completedUnitCount = progress.completedUnitCount
                            completedUnitCount += 1
                            progress.completedUnitCount = completedUnitCount

                            if pendingImageIdentifiers.isEmpty {
                                completeSync()
                            }
                        })
                    })
                }
            } else {
                completionHandler(SyncError.failedToLoadResponse)
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

    private var eventsObservers = [EventsServiceObserver]()

    private func reconstituteEventsFromDataStore() {
        let events = dataStore.getSavedEvents()
        let rooms = dataStore.getSavedRooms()
        let tracks = dataStore.getSavedTracks()

        if let events = events, let rooms = rooms, let tracks = tracks {
            self.events = events.flatMap { (event) -> Event2? in
                guard let room = rooms.first(where: { $0.roomIdentifier == event.roomIdentifier }) else { return nil }
                guard let track = tracks.first(where: { $0.trackIdentifier == event.trackIdentifier }) else { return nil }

                var posterGraphicData: Data?
                if let posterImageIdentifier = event.posterImageId {
                    posterGraphicData = imageCache.cachedImageData(for: posterImageIdentifier)
                }

                var bannerGraphicData: Data?
                if let bannerImageIdentifier = event.bannerImageId {
                    bannerGraphicData = imageCache.cachedImageData(for: bannerImageIdentifier)
                }

                return Event2(title: event.title,
                              abstract: event.abstract,
                              room: Room(name: room.name),
                              track: Track(name: track.name),
                              hosts: event.panelHosts,
                              startDate: event.startDateTime,
                              endDate: event.endDateTime,
                              eventDescription: event.eventDescription,
                              posterGraphicPNGData: posterGraphicData,
                              bannerGraphicPNGData: bannerGraphicData,
                              isFavourite: false)
            }
        }
    }

    func add(_ observer: EventsServiceObserver) {
        eventsObservers.append(observer)
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: makeRunningEvents())
        observer.eurofurenceApplicationDidUpdateUpcomingEvents(to: [])
        observer.eurofurenceApplicationDidUpdateEvents(to: events)
    }

    private func makeRunningEvents() -> [Event2] {
        let now = clock.currentDate
        return events.filter { (event) -> Bool in
            let range = DateInterval(start: event.startDate, end: event.endDate)
            return range.contains(now)
        }
    }

    private func makeUpcomingEvents() -> [Event2] {
        let now = clock.currentDate
        let range = DateInterval(start: now, end: now.addingTimeInterval(timeIntervalForUpcomingEventsSinceNow))
        return events.filter { (event) -> Bool in
            return event.startDate > now && range.contains(event.startDate)
        }
    }

    private func updateEvents(from response: APISyncResponse) {
        events = response.events.changed.flatMap({ (event) -> Event2? in
            guard let room = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier }) else { return nil }
            guard let track = response.tracks.changed.first(where: { $0.trackIdentifier == event.trackIdentifier }) else { return nil }

            var posterGraphicData: Data?
            if let posterImageIdentifier = event.posterImageId {
                posterGraphicData = imageCache.cachedImageData(for: posterImageIdentifier)
            }

            var bannerGraphicData: Data?
            if let bannerImageIdentifier = event.bannerImageId {
                bannerGraphicData = imageCache.cachedImageData(for: bannerImageIdentifier)
            }

            return Event2(title: event.title,
                          abstract: event.abstract,
                          room: Room(name: room.name),
                          track: Track(name: track.name),
                          hosts: event.panelHosts,
                          startDate: event.startDateTime,
                          endDate: event.endDateTime,
                          eventDescription: event.eventDescription,
                          posterGraphicPNGData: posterGraphicData,
                          bannerGraphicPNGData: bannerGraphicData,
                          isFavourite: false)
        })

        eventsObservers.forEach({ $0.eurofurenceApplicationDidUpdateEvents(to: events) })
    }

}
