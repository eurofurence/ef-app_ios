//
//  UserAuthenticationCoordinator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class UserAuthenticationCoordinator: LoginTaskDelegate, CredentialPersisterDelegate {

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

    func loginTask(_ task: LoginTask, didProduce credential: Credential) {
        let user = User(registrationNumber: credential.registrationNumber, username: credential.username)
        loggedInUser = user

        credentialPersister.persist(credential)
        loginCompletionHandler?(.success(user))
        userAuthenticationToken = credential.authenticationToken
        eventBus.post(DomainEvent.LoggedIn(user: user, authenticationToken: credential.authenticationToken))
    }

    func loginTaskDidFail(_ task: LoginTask) {
        loginCompletionHandler?(.failure)
    }

    // MARK: CredentialPersisterDelegate

    func credentialPersister(_ credentialPersister: CredentialPersister, didRetrieve credential: Credential) {
        userAuthenticationToken = credential.authenticationToken
        let user = User(registrationNumber: credential.registrationNumber, username: credential.username)
        loggedInUser = user
        eventBus.post(DomainEvent.LoggedIn(user: user, authenticationToken: credential.authenticationToken))
    }

}
