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
    private let privateMessagesController: PrivateMessagesController

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
        authenticationCoordinator.registeredDeviceToken = deviceToken
    }

    var localPrivateMessages: [Message] { return privateMessagesController.localPrivateMessages }

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        privateMessagesController.fetchPrivateMessages(completionHandler: completionHandler)
    }

    func markMessageAsRead(_ message: Message) {
        guard let token = authenticationCoordinator.userAuthenticationToken else { return }

        privateMessagesAPI.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)
    }

    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        completionHandler(authenticationCoordinator.loggedInUser)
    }

}
