//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum LoginResult {
    case success(User)
    case failure
}

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
    private let dateDistanceCalculator: DateDistanceCalculator
    private let conventionStartDateRepository: ConventionStartDateRepository
    private var syncResponse: APISyncResponse?

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
         conventionStartDateRepository: ConventionStartDateRepository) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
        self.clock = clock
        self.syncAPI = syncAPI
        self.dateDistanceCalculator = dateDistanceCalculator
        self.conventionStartDateRepository = conventionStartDateRepository

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
            if response == nil {
                completionHandler(SyncError.failedToLoadResponse)
            } else {
                self.syncResponse = response

                let groups = self.makeKnowledgeGroupsFromSyncResponse()
                let announcements = self.makeAnnouncementsFromSyncResponse()

                self.dataStore.performTransaction({ (transaction) in
                    transaction.saveKnowledgeGroups(groups)
                    transaction.saveAnnouncements(announcements)
                })

                self.privateMessagesController.fetchPrivateMessages { (_) in completionHandler(nil) }
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

    func fetchAnnouncements(completionHandler: @escaping ([Announcement2]) -> Void) {
        completionHandler(makeAnnouncementsFromSyncResponse())
    }

    func observeDaysUntilConvention(using observer: DaysUntilConventionServiceObserver) {
        let now = clock.currentDate
        let conventionStartTime = conventionStartDateRepository.conventionStartDate
        let distance = dateDistanceCalculator.calculateDays(between: now, and: conventionStartTime)
        observer.daysUntilConventionDidChange(to: distance)
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

}
