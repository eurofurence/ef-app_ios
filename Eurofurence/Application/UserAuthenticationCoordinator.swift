//
//  UserAuthenticationCoordinator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class UserAuthenticationCoordinator: CredentialPersisterDelegate {

    private let eventBus: EventBus
    var userAuthenticationToken: String?
    var registeredDeviceToken: Data?
    private var loginAPI: LoginAPI
    private var credentialPersister: CredentialPersister
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    var loggedInUser: User?
    private var loginCompletionHandler: ((LoginResult) -> Void)?

    var isLoggedIn: Bool {
        return userAuthenticationToken != nil
    }

    init(eventBus: EventBus,
         clock: Clock,
         credentialStore: CredentialStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginAPI: LoginAPI) {
        self.eventBus = eventBus
        self.loginAPI = loginAPI
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        credentialPersister = CredentialPersister(clock: clock, credentialStore: credentialStore)
        credentialPersister.loadCredential(delegate: self)
    }

    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        loginCompletionHandler = completionHandler

        if let user = loggedInUser {
            completionHandler(.success(user))
        } else {
            let request = LoginRequest(regNo: arguments.registrationNumber, username: arguments.username, password: arguments.password) { (result) in
                switch result {
                case .success(let response):
                    let credential = Credential(username: arguments.username,
                                                registrationNumber: arguments.registrationNumber,
                                                authenticationToken: response.token,
                                                tokenExpiryDate: response.tokenValidUntil)
                    let user = User(registrationNumber: credential.registrationNumber, username: credential.username)
                    self.loggedInUser = user

                    self.credentialPersister.persist(credential)
                    completionHandler(.success(user))
                    self.userAuthenticationToken = credential.authenticationToken
                    self.eventBus.post(DomainEvent.LoggedIn(user: user, authenticationToken: credential.authenticationToken))

                case .failure:
                    completionHandler(.failure)
                }
            }

            loginAPI.performLogin(request: request)
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

    // MARK: CredentialPersisterDelegate

    func credentialPersister(_ credentialPersister: CredentialPersister, didRetrieve credential: Credential) {
        userAuthenticationToken = credential.authenticationToken
        let user = User(registrationNumber: credential.registrationNumber, username: credential.username)
        loggedInUser = user
        eventBus.post(DomainEvent.LoggedIn(user: user, authenticationToken: credential.authenticationToken))
    }

}
