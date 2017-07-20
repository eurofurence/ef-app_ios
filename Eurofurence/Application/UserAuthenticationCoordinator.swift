//
//  UserAuthenticationCoordinator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class UserAuthenticationCoordinator {

    var userAuthenticationToken: String?
    var registeredDeviceToken: Data?
    private var loginAPI: LoginAPI
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var clock: Clock
    private var loginCredentialStore: LoginCredentialStore
    private var userAuthenticationTokenValid = false
    private var loginObservers = [LoginObserver]()
    private var authenticationStateObservers = [AuthenticationStateObserver]()
    private var userRegistrationNumber: Int?
    private var loggedInUsername: String?
    private var loggedInUser: User?

    private var isLoggedIn: Bool {
        return userAuthenticationToken != nil
    }

    init(clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginAPI: LoginAPI) {
        self.loginAPI = loginAPI
        self.clock = clock
        self.loginCredentialStore = loginCredentialStore
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration

        if let credential = loginCredentialStore.persistedCredential, isCredentialValid(credential) {
            userAuthenticationToken = credential.authenticationToken
        }
    }

    func add(_ loginObserver: LoginObserver) {
        loginObservers.append(loginObserver)
    }

    func remove(_ loginObserver: LoginObserver) {
        guard let idx = loginObservers.index(where: { $0 === loginObserver }) else { return }
        loginObservers.remove(at: idx)
    }

    func add(_ authenticationStateObserver: AuthenticationStateObserver) {
        authenticationStateObservers.append(authenticationStateObserver)

        if isLoggedIn {
            authenticationStateObserver.loggedIn(as: User(registrationNumber: 0, username: ""))
        }
    }

    func login(_ arguments: LoginArguments) {
        if isLoggedIn {
            notifyLoginSucceeded()
        } else {
            performLogin(arguments: arguments)
        }
    }

    private func performLogin(arguments: LoginArguments) {
        userRegistrationNumber = arguments.registrationNumber
        loginAPI.performLogin(arguments: makeAPILoginParameters(from: arguments),
                              completionHandler: handleLoginResult)
    }

    private func makeAPILoginParameters(from args: LoginArguments) -> APILoginParameters {
        return APILoginParameters(regNo: args.registrationNumber, username: args.username, password: args.password)
    }

    private func handleLoginResult(_ result: APIResponse<APILoginResponse>) {
        switch result {
        case .success(let response):
            processLoginResponse(response)

        case .failure:
            notifyLoginFailed()
        }
    }

    private func processLoginResponse(_ response: APILoginResponse) {
        guard let userRegistrationNumber = userRegistrationNumber else { return }

        let credential = LoginCredential(username: response.username,
                                         registrationNumber: userRegistrationNumber,
                                         authenticationToken: response.token,
                                         tokenExpiryDate: response.tokenValidUntil)

        loggedInUser = User(registrationNumber: userRegistrationNumber, username: response.username)
        loginCredentialStore.store(credential)
        notifyLoginSucceeded()
        userAuthenticationToken = credential.authenticationToken

        if let registeredDeviceToken = registeredDeviceToken {
            remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                        userAuthenticationToken: userAuthenticationToken)
        }
    }

    private func notifyLoginSucceeded() {
        loginObservers.forEach { $0.userDidLogin() }

        guard let loggedInUser = loggedInUser else { return }
        authenticationStateObservers.forEach { $0.loggedIn(as: loggedInUser) }
    }

    private func notifyLoginFailed() {
        loginObservers.forEach { $0.userDidFailToLogIn() }
    }

    private func isCredentialValid(_ credential: LoginCredential) -> Bool {
        return clock.currentDate.compare(credential.tokenExpiryDate) == .orderedAscending
    }

}
