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
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var clock: Clock
    private var loginCredentialStore: LoginCredentialStore
    private var loginAPI: V2LoginAPI
    private var userAuthenticationTokenValid = false
    private var userAuthenticationObservers = [UserAuthenticationObserver]()

    init(clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         jsonPoster: JSONPoster,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration) {
        self.clock = clock
        self.loginCredentialStore = loginCredentialStore
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        loginAPI = V2LoginAPI(jsonPoster: jsonPoster)

        if let credential = loginCredentialStore.persistedCredential, isCredentialValid(credential) {
            userAuthenticationToken = credential.authenticationToken
        }
    }

    func add(_ userAuthenticationObserver: UserAuthenticationObserver) {
        userAuthenticationObservers.append(userAuthenticationObserver)
    }

    func remove(_ userAuthenticationObserver: UserAuthenticationObserver) {
        guard let idx = userAuthenticationObservers.index(where: { $0 === userAuthenticationObserver }) else { return }
        userAuthenticationObservers.remove(at: idx)
    }

    func login(_ arguments: LoginArguments) {
        if userAuthenticationToken == nil {
            performLogin(arguments: arguments)
        } else {
            notifyUserAuthorized()
        }
    }

    private func performLogin(arguments: LoginArguments) {
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
            notifyUserUnauthorized()
        }
    }

    private func processLoginResponse(_ response: APILoginResponse) {
        let credential = LoginCredential(username: response.username,
                                         registrationNumber: response.uid,
                                         authenticationToken: response.token,
                                         tokenExpiryDate: response.tokenValidUntil)

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
