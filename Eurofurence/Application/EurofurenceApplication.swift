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

    static var shared: EurofurenceApplication = {
        let JSONSession = URLSessionBasedJSONSession()
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: JSONSession)
        let tokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                             appVersion: BundleAppVersionProviding(),
                                                                             firebaseAdapter: FirebaseMessagingAdapter(),
                                                                             fcmRegistration: fcmRegistration)

        struct DummyUserPreferences: UserPreferences {
            var refreshStoreOnLaunch: Bool = true
        }

        struct DummyEurofurenceDataStore: EurofurenceDataStore {
            func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void) {
                completionHandler(.present)
            }
        }

        return EurofurenceApplication(userPreferences: DummyUserPreferences(),
                                      dataStore: DummyEurofurenceDataStore(),
                                      remoteNotificationsTokenRegistration: tokenRegistration,
                                      pushPermissionsRequester: ApplicationPushPermissionsRequester(),
                                      pushPermissionsStateProviding: UserDefaultsWitnessedSystemPushPermissionsRequest(),
                                      clock: SystemClock(),
                                      credentialStore: KeychainCredentialStore(),
                                      loginAPI: V2LoginAPI(JSONSession: JSONSession),
                                      privateMessagesAPI: V2PrivateMessagesAPI(jsonSession: JSONSession))
    }()

    private let eventBus = EventBus()
    private let userPreferences: UserPreferences
    private let dataStore: EurofurenceDataStore
    private let privateMessagesAPI: PrivateMessagesAPI
    private let pushPermissionsRequester: PushPermissionsRequester
    private let pushPermissionsStateProviding: PushPermissionsStateProviding
    private let remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private let authenticationCoordinator: UserAuthenticationCoordinator
    private let remoteNotificationRegistrationController: RemoteNotificationRegistrationController

    init(userPreferences: UserPreferences,
         dataStore: EurofurenceDataStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         pushPermissionsRequester: PushPermissionsRequester,
         pushPermissionsStateProviding: PushPermissionsStateProviding,
         clock: Clock,
         credentialStore: CredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.privateMessagesAPI = privateMessagesAPI
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding

        if pushPermissionsStateProviding.requestedPushNotificationAuthorization {
            pushPermissionsRequester.requestPushPermissions()
        }

        remoteNotificationRegistrationController = RemoteNotificationRegistrationController(eventBus: eventBus,
                                                                                            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration)
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
        authenticationCoordinator.registeredDeviceToken = deviceToken
    }

    private(set) var localPrivateMessages: [Message] = []

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        if let token = authenticationCoordinator.userAuthenticationToken {
            privateMessagesAPI.loadPrivateMessages(authorizationToken: token) { response in
                switch response {
                case .success(let response):
                    let messages = response.messages.map(self.makeMessage).sorted(by: { (first, second) -> Bool in
                        return first.receivedDateTime.compare(second.receivedDateTime) == .orderedDescending
                    })

                    self.localPrivateMessages = messages
                    completionHandler(.success(messages))

                case .failure:
                    completionHandler(.failedToLoad)
                }
            }
        } else {
            completionHandler(.userNotAuthenticated)
        }
    }

    func markMessageAsRead(_ message: Message) {
        guard let token = authenticationCoordinator.userAuthenticationToken else { return }

        privateMessagesAPI.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)
    }

    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        completionHandler(authenticationCoordinator.loggedInUser)
    }

    private func makeMessage(from apiMessage: APIPrivateMessage) -> Message {
        return Message(identifier: apiMessage.id,
                       authorName: apiMessage.authorName,
                       receivedDateTime: apiMessage.receivedDateTime,
                       subject: apiMessage.subject,
                       contents: apiMessage.message,
                       isRead: apiMessage.readDateTime != nil)
    }

}
