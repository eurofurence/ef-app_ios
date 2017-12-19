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

        return EurofurenceApplication(remoteNotificationsTokenRegistration: tokenRegistration,
                                      pushPermissionsRequester: ApplicationPushPermissionsRequester(),
                                      pushPermissionsStateProviding: UserDefaultsWitnessedSystemPushPermissionsRequest(),
                                      clock: SystemClock(),
                                      loginCredentialStore: KeychainLoginCredentialStore(),
                                      loginAPI: V2LoginAPI(JSONSession: JSONSession),
                                      privateMessagesAPI: V2PrivateMessagesAPI(JSONSession: JSONSession))
    }()

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var authenticationCoordinator: UserAuthenticationCoordinator
    private var registeredDeviceToken: Data?
    private let privateMessagesAPI: PrivateMessagesAPI
    private let pushPermissionsRequester: PushPermissionsRequester
    private let pushPermissionsStateProviding: PushPermissionsStateProviding

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         pushPermissionsRequester: PushPermissionsRequester,
         pushPermissionsStateProviding: PushPermissionsStateProviding,
         clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.privateMessagesAPI = privateMessagesAPI
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding

        if pushPermissionsStateProviding.requestedPushNotificationAuthorization {
            pushPermissionsRequester.requestPushPermissions()
        }

        authenticationCoordinator = UserAuthenticationCoordinator(clock: clock,
                                                                  loginCredentialStore: loginCredentialStore,
                                                                  remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                                  loginAPI: loginAPI)
    }

    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void) {

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
        registeredDeviceToken = deviceToken
        authenticationCoordinator.registeredDeviceToken = deviceToken
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                                    userAuthenticationToken: authenticationCoordinator.userAuthenticationToken) { _ in }
    }

    private(set) var localPrivateMessages: [Message] = []

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        if let token = authenticationCoordinator.userAuthenticationToken {
            privateMessagesAPI.loadPrivateMessages(authorizationToken: token) { response in
                switch response {
                case .success(let response):
                    let messages = response.messages.map(self.makeMessage)
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
