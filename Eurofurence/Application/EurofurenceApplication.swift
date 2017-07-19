//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EurofurenceApplication {

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var clock: Clock
    private var loginCredentialStore: LoginCredentialStore
    private var jsonPoster: JSONPoster
    private var userAuthenticationTokenValid = false
    private var registeredDeviceToken: Data?
    private var userAuthenticationToken: String?
    private var userAuthenticationObservers = [UserAuthenticationObserver]()

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         jsonPoster: JSONPoster) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.clock = clock
        self.loginCredentialStore = loginCredentialStore
        self.jsonPoster = jsonPoster

        if let credential = loginCredentialStore.persistedCredential, isCredentialValid(credential) {
            userAuthenticationToken = credential.authenticationToken
        }
    }

    func add(_ userAuthenticationObserver: UserAuthenticationObserver) {
        userAuthenticationObservers.append(userAuthenticationObserver)
    }

    func login(_ arguments: LoginArguments) {
        if userAuthenticationToken == nil {
            performLogin(arguments: arguments)
        } else {
            notifyUserAuthorized()
        }
    }

    func registerRemoteNotifications(deviceToken: Data) {
        registeredDeviceToken = deviceToken
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                                    userAuthenticationToken: userAuthenticationToken)
    }

    private func performLogin(arguments: LoginArguments) {
        do {
            let postArguments: [String : Any] = ["RegNo": arguments.registrationNumber,
                                                 "Username": arguments.username,
                                                 "Password": arguments.password]
            let jsonData = try JSONSerialization.data(withJSONObject: postArguments, options: [])
            jsonPoster.post("https://app.eurofurence.org/api/v2/Tokens/RegSys",
                            body: jsonData,
                            completionHandler: handleNetworkLoginResponse)
        } catch {
            print("Unable to perform login due to error: \(error)")
        }
    }

    private func handleNetworkLoginResponse(_ responseData: Data?) {
        guard let responseData = responseData,
              let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments),
              let jsonDictionary = json as? [String : Any],
              let response = JSONLoginResponse(json: jsonDictionary) else {
            notifyUserUnauthorized()
            return
        }

        let credential = LoginCredential(username: response.username,
                                         registrationNumber: response.userID,
                                         authenticationToken: response.authToken,
                                         tokenExpiryDate: response.authTokenExpiry)
        loginCredentialStore.store(credential)
        notifyUserAuthorized()
        userAuthenticationToken = credential.authenticationToken

        if let registeredDeviceToken = registeredDeviceToken {
            remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                        userAuthenticationToken: userAuthenticationToken)
        }
    }

    private func notifyUserAuthorized() {
        userAuthenticationObservers.forEach { $0.userAuthenticationAuthorized() }
    }

    private func notifyUserUnauthorized() {
        userAuthenticationObservers.forEach { $0.userAuthenticationUnauthorized() }
    }

    private func isCredentialValid(_ credential: LoginCredential) -> Bool {
        return clock.currentDate.compare(credential.tokenExpiryDate) == .orderedAscending
    }

}
