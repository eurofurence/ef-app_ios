//
//  UserAuthenticationCoordinator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class UserAuthenticationCoordinator: LoginTaskDelegate, CredentialPersisterDelegate {

    var userAuthenticationToken: String?
    var registeredDeviceToken: Data?
    private var loginAPI: LoginAPI
    private var credentialPersister: CredentialPersister
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var authenticationStateObservers = [AuthenticationStateObserver]()
    private var loggedInUser: User?
    private var loginCompletionHandler: ((LoginResult) -> Void)?

    var isLoggedIn: Bool {
        return userAuthenticationToken != nil
    }

    init(clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginAPI: LoginAPI) {
        self.loginAPI = loginAPI
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        credentialPersister = CredentialPersister(clock: clock, loginCredentialStore: loginCredentialStore)
        credentialPersister.loadCredential(delegate: self)
    }

    func add(_ authenticationStateObserver: AuthenticationStateObserver) {
        authenticationStateObservers.append(authenticationStateObserver)

        if let loggedInUser = loggedInUser {
            authenticationStateObserver.loggedIn(as: loggedInUser)
        }
    }

    func remove(_ authenticationStateObserver: AuthenticationStateObserver) {
        guard let idx = authenticationStateObservers.index(where: { $0 === authenticationStateObserver }) else { return }
        authenticationStateObservers.remove(at: idx)
    }

    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        loginCompletionHandler = completionHandler

        if isLoggedIn {
            notifyLoginSucceeded()
        } else {
            LoginTask(delegate: self, arguments: arguments, loginAPI: loginAPI).start()
        }
    }

    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                    userAuthenticationToken: nil) { error in
            if error != nil {
                completionHandler(.failure)
            } else {
                self.credentialPersister.deleteCredential()
                self.loggedInUser = nil
                self.userAuthenticationToken = nil
                completionHandler(.success)
            }
        }
    }

    // MARK: LoginTaskDelegate

    func loginTask(_ task: LoginTask, didProduce loginCredential: LoginCredential) {
        loggedInUser = User(registrationNumber: loginCredential.registrationNumber, username: loginCredential.username)
        credentialPersister.persist(loginCredential)
        notifyLoginSucceeded()
        userAuthenticationToken = loginCredential.authenticationToken

        if let registeredDeviceToken = registeredDeviceToken {
            remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                        userAuthenticationToken: userAuthenticationToken) { _ in }
        }
    }

    func loginTaskDidFail(_ task: LoginTask) {
        loginCompletionHandler?(.failure)
    }

    // MARK: CredentialPersisterDelegate

    func credentialPersister(_ credentialPersister: CredentialPersister, didRetrieve loginCredential: LoginCredential) {
        userAuthenticationToken = loginCredential.authenticationToken
        loggedInUser = User(registrationNumber: loginCredential.registrationNumber, username: loginCredential.username)
    }

    // MARK: Private

    private func notifyLoginSucceeded() {
        loginCompletionHandler?(.success)

        guard let loggedInUser = loggedInUser else { return }
        authenticationStateObservers.forEach { $0.loggedIn(as: loggedInUser) }
    }

}
