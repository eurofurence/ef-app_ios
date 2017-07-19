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
        guard let responseData = responseData,
              let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments),
              let jsonDictionary = json as? [String : Any],
              let response = LoginResponse(json: jsonDictionary) else {
            loginObservers.forEach { $0.loginFailed() }
            return
        }

        let credential = LoginCredential(username: response.username,
                                         registrationNumber: response.userID,
                                         authenticationToken: response.authToken,
                                         tokenExpiryDate: response.authTokenExpiry)
        loginCredentialStore.store(credential)
        loginObservers.forEach { $0.loginSucceeded() }
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

fileprivate struct LoginResponse {

    private static let dateFormatter = Iso8601DateFormatter()

    var userID: Int
    var username: String
    var authToken: String
    var authTokenExpiry: Date

    init?(json: [String : Any]) {
        var userID: Int = 0
        guard let username = json["Username"] as? String,
               let userIDString = json["Uid"] as? String,
               let authToken = json["Token"] as? String,
               let dateString = json["TokenValidUntil"] as? String,
               let expiry = LoginResponse.dateFormatter.date(from: dateString),
               Scanner(string: userIDString).scanInt(&userID) else {
            return nil
        }

        self.userID = userID
        self.username = username
        self.authToken = authToken
        self.authTokenExpiry = expiry
    }

}
