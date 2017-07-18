//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EurofurenceApplication: LoginStateObserver {

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var clock: Clock
    private var loginCredentialStore: LoginCredentialStore
    private var userAuthenticationTokenValid = false
    private var registeredDeviceToken: Data?
    private var userAuthenticationToken: String?

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginController: LoginController,
         clock: Clock,
         loginCredentialStore: LoginCredentialStore) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.clock = clock
        self.loginCredentialStore = loginCredentialStore

        loginController.add(self)

        if let credential = loginCredentialStore.persistedCredential, isCredentialValid(credential) {
            userAuthenticationToken = credential.authenticationToken
        }
    }

    func registerRemoteNotifications(deviceToken: Data) {
        registeredDeviceToken = deviceToken
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                                    userAuthenticationToken: userAuthenticationToken)
    }

    func userDidLogin(credential: LoginCredential) {
        if isCredentialValid(credential) {
            userAuthenticationToken = credential.authenticationToken
            loginCredentialStore.store(credential)
        }

        guard let registeredDeviceToken = registeredDeviceToken else { return }

        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                    userAuthenticationToken: userAuthenticationToken)
    }

    func userDidLogout() {
        loginCredentialStore.deletePersistedToken()
    }

    private func isCredentialValid(_ credential: LoginCredential) -> Bool {
        return clock.currentDate.compare(credential.tokenExpiryDate) == .orderedAscending
    }

}
