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
    private let remoteNotificationRegistrationController: RemoteNotificationRegistrationController
    private let authenticationCoordinator: UserAuthenticationCoordinator
    private let privateMessagesController: PrivateMessagesController
    private let syncAPI: SyncAPI
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
         syncAPI: SyncAPI) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
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
                completionHandler(persistedGroups)
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
                completionHandler(nil)
                self.syncResponse = response

                let groups = self.makeKnowledgeGroupsFromSyncResponse()

                self.dataStore.beginTransaction({ (transaction) in
                    transaction.saveKnowledgeGroups(groups)
                })
            }
        }

        return Progress()
    }

    private func makeKnowledgeGroupsFromSyncResponse() -> [KnowledgeGroup2] {
        if let syncResponse = syncResponse {
            return syncResponse.knowledgeGroups.changed.map({ (group) -> KnowledgeGroup2 in
                let entriesForGroup = syncResponse.knowledgeEntries.changed.filter({ $0.groupIdentifier == group.identifier }).map({ (entry) -> KnowledgeEntry2 in
                    return KnowledgeEntry2(title: entry.title)
                })

                return KnowledgeGroup2(title: group.groupName, groupDescription: group.groupDescription, entries: entriesForGroup)
            })
        } else {
            return []
        }
    }

}
