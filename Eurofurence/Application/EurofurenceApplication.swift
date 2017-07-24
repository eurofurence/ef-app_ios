//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EurofurenceApplication {

    static var shared: EurofurenceApplication = {
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        let fcmRegistration = EurofurenceFCMDeviceRegistration(jsonPoster: URLSessionJSONPoster())
        let tokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                             appVersion: BundleAppVersionProviding(),
                                                                             firebaseAdapter: FirebaseMessagingAdapter(),
                                                                             fcmRegistration: fcmRegistration)

        struct DummyPrivateMessagesAPI: PrivateMessagesAPI {

            func loadPrivateMessages(completionHandler: @escaping (APIResponse<Any>) -> Void) {

            }

        }

        return EurofurenceApplication(remoteNotificationsTokenRegistration: tokenRegistration,
                                      clock: SystemClock(),
                                      loginCredentialStore: KeychainLoginCredentialStore(),
                                      loginAPI: V2LoginAPI(jsonPoster: URLSessionJSONPoster()),
                                      privateMessagesAPI: DummyPrivateMessagesAPI())
    }()

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var authenticationCoordinator: UserAuthenticationCoordinator
    private var registeredDeviceToken: Data?
    private var privateMessagesObservers = [PrivateMessagesObserver]()
    private let privateMessagesAPI: PrivateMessagesAPI

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.privateMessagesAPI = privateMessagesAPI

        authenticationCoordinator = UserAuthenticationCoordinator(clock: clock,
                                                                  loginCredentialStore: loginCredentialStore,
                                                                  remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                                  loginAPI: loginAPI)
    }

    func add(_ loginObserver: LoginObserver) {
        authenticationCoordinator.add(loginObserver)
    }

    func remove(_ loginObserver: LoginObserver) {
        authenticationCoordinator.remove(loginObserver)
    }

    func add(_ authenticationStateObserver: AuthenticationStateObserver) {
        authenticationCoordinator.add(authenticationStateObserver)
    }

    func remove(_ authenticationStateObserver: AuthenticationStateObserver) {
        authenticationCoordinator.remove(authenticationStateObserver)
    }

    func add(_ privateMessagesObserver: PrivateMessagesObserver) {
        privateMessagesObservers.append(privateMessagesObserver)
    }

    func login(_ arguments: LoginArguments) {
        authenticationCoordinator.login(arguments)
    }

    func registerRemoteNotifications(deviceToken: Data) {
        registeredDeviceToken = deviceToken
        authenticationCoordinator.registeredDeviceToken = deviceToken
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                                    userAuthenticationToken: authenticationCoordinator.userAuthenticationToken)
    }

    func fetchPrivateMessages() {
        if authenticationCoordinator.isLoggedIn {
            privateMessagesAPI.loadPrivateMessages { response in
                switch response {
                case .success(_):
                    break

                case .failure:
                    self.privateMessagesObservers.forEach({ $0.failedToLoadPrivateMessages() })
                }
            }
        }

        privateMessagesObservers.forEach({ $0.privateMessagesLoaded([]) })
    }

}
