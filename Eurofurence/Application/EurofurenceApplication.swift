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

        return EurofurenceApplication(remoteNotificationsTokenRegistration: tokenRegistration,
                                      clock: SystemClock(),
                                      loginCredentialStore: KeychainLoginCredentialStore(),
                                      loginAPI: V2LoginAPI(jsonPoster: URLSessionJSONPoster()))
    }()

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var authenticationCoordinator: UserAuthenticationCoordinator
    private var registeredDeviceToken: Data?

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         loginAPI: LoginAPI) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
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

    func login(_ arguments: LoginArguments) {
        authenticationCoordinator.login(arguments)
    }

    func registerRemoteNotifications(deviceToken: Data) {
        registeredDeviceToken = deviceToken
        authenticationCoordinator.registeredDeviceToken = deviceToken
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                                    userAuthenticationToken: authenticationCoordinator.userAuthenticationToken)
    }

}
