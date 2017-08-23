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

    func loginTask(_ task: LoginTask, didProduce loginCredential: LoginCredential) {
        let user = User(registrationNumber: loginCredential.registrationNumber, username: loginCredential.username)
        loggedInUser = user

        credentialPersister.persist(loginCredential)
        loginCompletionHandler?(.success(user))
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

}
