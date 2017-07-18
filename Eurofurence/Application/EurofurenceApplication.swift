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
    private var jsonPoster: JSONPoster
    private var userAuthenticationTokenValid = false
    private var registeredDeviceToken: Data?
    private var userAuthenticationToken: String?

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginController: LoginController,
         clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         jsonPoster: JSONPoster) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.clock = clock
        self.loginCredentialStore = loginCredentialStore
        self.jsonPoster = jsonPoster

        loginController.add(self)

        if let credential = loginCredentialStore.persistedCredential, isCredentialValid(credential) {
            userAuthenticationToken = credential.authenticationToken
        }
    }

    func login(registrationNumber: Int, username: String, password: String) {
        do {
            let postArguments: [String : Any] = ["RegNo": registrationNumber,
                                                 "Username": username,
                                                 "Password": password]
            let jsonData = try JSONSerialization.data(withJSONObject: postArguments, options: [])
            jsonPoster.post("https://app.eurofurence.org/api/v2/Tokens/RegSys", body: jsonData)
        } catch {
            print("Unable to perform login due to error: \(error)")
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
