//
//  ApplicationTestBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class ApplicationTestBuilder {
    
    struct Context {
        var application: EurofurenceApplication
        
        var capturingTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var capturingLoginCredentialsStore: CapturingLoginCredentialStore
        var loginAPI: CapturingLoginAPI
        var privateMessagesAPI: CapturingPrivateMessagesAPI
        
        var authenticationToken: String? {
            return capturingLoginCredentialsStore.persistedCredential?.authenticationToken
        }
        
        
        func registerForRemoteNotifications(_ deviceToken: Data = Data()) {
            application.registerForRemoteNotifications(deviceToken: deviceToken)
        }
        
        func login(registrationNumber: Int = 0,
                   username: String = "",
                   password: String = "",
                   completionHandler: @escaping (LoginResult) -> Void = { _ in }) {
            let arguments = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            application.login(arguments, completionHandler: completionHandler)
        }
        
    }
    
    private let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var capturingLoginCredentialsStore = CapturingLoginCredentialStore()
    private var stubClock = StubClock()
    private let loginAPI = CapturingLoginAPI()
    private let privateMessagesAPI = CapturingPrivateMessagesAPI()
    
    func with(_ currentDate: Date) -> ApplicationTestBuilder {
        stubClock = StubClock(currentDate: currentDate)
        return self
    }
    
    func with(_ persistedCredential: LoginCredential?) -> ApplicationTestBuilder {
        capturingLoginCredentialsStore = CapturingLoginCredentialStore(persistedCredential: persistedCredential)
        return self
    }
    
    func loggedInWithValidCredential() -> ApplicationTestBuilder {
        let credential = LoginCredential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        return with(credential)
    }
    
    func build() -> Context {
        let app = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration,
                                         clock: stubClock,
                                         loginCredentialStore: capturingLoginCredentialsStore,
                                         loginAPI: loginAPI,
                                         privateMessagesAPI: privateMessagesAPI)
        return Context(application: app,
                       capturingTokenRegistration: capturingTokenRegistration,
                       capturingLoginCredentialsStore: capturingLoginCredentialsStore,
                       loginAPI: loginAPI,
                       privateMessagesAPI: privateMessagesAPI)
    }
    
}
