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
                let groups = self.makeKnowledgeGroupsFromSyncResponse()
                completionHandler(groups)
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

                let groups = self.makeKnowledgeGroupsFromSyncResponse()
                let announcements = self.makeAnnouncementsFromSyncResponse()

                self.dataStore.performTransaction({ (transaction) in
                    transaction.saveKnowledgeGroups(groups)
                    transaction.saveAnnouncements(announcements)
                })

                self.announcementsObservers.forEach({ $0.eurofurenceApplicationDidChangeUnreadAnnouncements(to: self.makeAnnouncementsFromSyncResponse()) })
                self.updateEvents(from: response)

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
        observer.eurofurenceApplicationDidChangeUnreadAnnouncements(to: makeAnnouncementsFromSyncResponse())
        announcementsObservers.append(observer)
    }

    func add(_ observer: ConventionCountdownServiceObserver) {
        conventionCountdownController.observeDaysUntilConvention(using: observer)
    }

    func add(_ observer: AuthenticationStateObserver) {
        authenticationCoordinator.add(observer)
    }

    func add(_ observer: EventsServiceObserver) {
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: events)
    }

    private func makeAnnouncementsFromSyncResponse() -> [Announcement2] {
        if let syncResponse = syncResponse {
            let sortedAnnouncements = syncResponse.announcements.changed.sorted(by: { (first, second) -> Bool in
                return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
            })

            return Announcement2.fromServerModels(sortedAnnouncements)
        } else {
            return []
        }
    }

    private func makeKnowledgeGroupsFromSyncResponse() -> [KnowledgeGroup2] {
        if let syncResponse = syncResponse {
            return KnowledgeGroup2.fromServerModels(groups: syncResponse.knowledgeGroups.changed, entries: syncResponse.knowledgeEntries.changed)
        } else {
            return []
        }
    }

    private func updateEvents(from response: APISyncResponse) {
        events = response.events.changed.flatMap({ (event) -> Event2? in
            guard let room = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier }) else { return nil }

            return Event2(title: event.title,
                          room: Room(name: room.name),
                          startDate: event.startDateTime,
                          secondsUntilEventBegins: 0)
        })
    }

}
