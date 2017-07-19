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
    private let dateFormatter = Iso8601DateFormatter()
    private var loginObservers = [LoginObserver]()

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

    func add(_ loginObserver: LoginObserver) {
        loginObservers.append(loginObserver)
    }

    func login(_ arguments: LoginArguments) {
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
        guard let responseData = responseData else {
            loginObservers.forEach { $0.loginFailed() }
            return
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) else { return }
        guard let jsonDictionary = jsonObject as? [String : Any] else { return }
        guard let username = jsonDictionary["Username"] as? String else { return }
        guard let userIDString = jsonDictionary["Uid"] as? String else { return }

        var userID: Int = 0
        guard Scanner(string: userIDString).scanInt(&userID) else { return }

        guard let authToken = jsonDictionary["Token"] as? String else { return }
        guard let dateString = jsonDictionary["TokenValidUntil"] as? String else { return }
        guard let expiry = dateFormatter.date(from: dateString) else { return }

        let credential = LoginCredential(username: username,
                                         registrationNumber: userID,
                                         authenticationToken: authToken,
                                         tokenExpiryDate: expiry)
        loginCredentialStore.store(credential)
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
