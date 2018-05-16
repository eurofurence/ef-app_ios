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
    private let conventionCountdownController: ConventionCountdownController
    private var syncResponse: APISyncResponse?
    private var knowledgeGroups = [KnowledgeGroup2]()
    private var announcements = [Announcement2]()
    private var events = [Event2]()

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
         dateDistanceCalculator: DateDistanceCalculator,
         conventionStartDateRepository: ConventionStartDateRepository,
         significantTimeChangeEventSource: SignificantTimeChangeEventSource) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
        self.clock = clock
        self.syncAPI = syncAPI

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
    }

    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void) {
        dataStore.resolveContentsState { (state) in
            switch state {
            case .empty:
                completionHandler(.absent)

            case .present:
                if self.userPreferences.refreshStoreOnLaunch {
                    completionHandler(.stale)
                } else {
                    completionHandler(.available)
                }
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
        dataStore.fetchKnowledgeGroups { (persistedGroups) in
            if let persistedGroups = persistedGroups {
                completionHandler(persistedGroups.sorted())
            } else {
                completionHandler(self.knowledgeGroups)
            }
        }
    }

    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        enum SyncError: Error {
            case failedToLoadResponse
        }

        syncAPI.fetchLatestData { (response) in
            if let response = response {
                self.syncResponse = response

                self.updateEvents(from: response)
                self.updateKnowledgeGroups(from: response)
                self.updateAnnouncements(from: response)

                self.dataStore.performTransaction({ (transaction) in
                    transaction.saveKnowledgeGroups(self.knowledgeGroups)
                    transaction.saveAnnouncements(self.announcements)
                })

                self.announcementsObservers.forEach({ $0.eurofurenceApplicationDidChangeUnreadAnnouncements(to: self.announcements) })

                let runningEvents = self.makeRunningEvents()
                self.eventsObservers.forEach({ $0.eurofurenceApplicationDidUpdateRunningEvents(to: runningEvents) })

                self.privateMessagesController.fetchPrivateMessages { (_) in completionHandler(nil) }
            } else {
                completionHandler(SyncError.failedToLoadResponse)
            }
        }

        return Progress()
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "mailto" {
            return .externalURL(url)
        }

        return .web(url)
    }

    private var announcementsObservers = [AnnouncementsServiceObserver]()
    func add(_ observer: AnnouncementsServiceObserver) {
        observer.eurofurenceApplicationDidChangeUnreadAnnouncements(to: announcements)
        announcementsObservers.append(observer)
    }

    func add(_ observer: ConventionCountdownServiceObserver) {
        conventionCountdownController.observeDaysUntilConvention(using: observer)
    }

    func add(_ observer: AuthenticationStateObserver) {
        authenticationCoordinator.add(observer)
    }

    private var eventsObservers = [EventsServiceObserver]()
    func add(_ observer: EventsServiceObserver) {
        eventsObservers.append(observer)
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: makeRunningEvents())
    }

    private func makeRunningEvents() -> [Event2] {
        let now = clock.currentDate
        return events.filter { (event) -> Bool in
            let range = DateInterval(start: event.startDate, end: event.endDate)
            return range.contains(now)
        }
    }

    private func updateAnnouncements(from response: APISyncResponse) {
        let sortedAnnouncements = response.announcements.changed.sorted(by: { (first, second) -> Bool in
            return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
        })

        announcements = Announcement2.fromServerModels(sortedAnnouncements)
    }

    private func updateKnowledgeGroups(from response: APISyncResponse) {
        knowledgeGroups = KnowledgeGroup2.fromServerModels(groups: response.knowledgeGroups.changed,
                                                           entries: response.knowledgeEntries.changed)
    }

    private func updateEvents(from response: APISyncResponse) {
        events = response.events.changed.flatMap({ (event) -> Event2? in
            guard let room = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier }) else { return nil }

            return Event2(title: event.title,
                          room: Room(name: room.name),
                          startDate: event.startDateTime,
                          endDate: event.endDateTime)
        })
    }

}
