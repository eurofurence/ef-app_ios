//
//  UserAuthenticationCoordinator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class UserAuthenticationCoordinator {

    private let eventBus: EventBus
    private let loginAPI: LoginAPI
    private let remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private let credentialPersister: CredentialPersister
    private var userAuthenticationToken: String?
    private var registeredDeviceToken: Data?
    private var loggedInUser: User?

    init(eventBus: EventBus,
         clock: Clock,
         credentialStore: CredentialStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginAPI: LoginAPI) {
        self.eventBus = eventBus
        self.loginAPI = loginAPI
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        credentialPersister = CredentialPersister(clock: clock, credentialStore: credentialStore)
        credentialPersister.loadCredential(completionHandler: updateCurrentUser)
        eventBus.subscribe(consumer: BlockEventConsumer(block: remoteNotificationTokenDidChange))
    }

    func login(_ args: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        if let user = loggedInUser {
            completionHandler(.success(user))
            return
        }

        let request = LoginRequest(regNo: args.registrationNumber, username: args.username, password: args.password)
        loginAPI.performLogin(request: request) { (response) in
            if let response = response {
                self.handleLoginSuccess(args, response: response, completionHandler: completionHandler)
            } else {
                completionHandler(.failure)
            }
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

    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        completionHandler(loggedInUser)
    }

    // MARK: Private

    private func remoteNotificationTokenDidChange(_ event: DomainEvent.RemoteNotificationRegistrationSucceeded) {
        registeredDeviceToken = event.deviceToken
    }

    private func handleLoginSuccess(_ args: LoginArguments,
                                    response: LoginResponse,
                                    completionHandler: @escaping (LoginResult) -> Void) {
        let credential = Credential(username: args.username,
                                    registrationNumber: args.registrationNumber,
                                    authenticationToken: response.token,
                                    tokenExpiryDate: response.tokenValidUntil)
        credentialPersister.persist(credential)
        updateCurrentUser(from: credential)
        completionHandler(.success(loggedInUser!))
    }

    private func updateCurrentUser(from credential: Credential) {
        userAuthenticationToken = credential.authenticationToken
        let user = User(registrationNumber: credential.registrationNumber, username: credential.username)
        loggedInUser = user
        eventBus.post(DomainEvent.LoggedIn(user: user, authenticationToken: credential.authenticationToken))
    }

}
