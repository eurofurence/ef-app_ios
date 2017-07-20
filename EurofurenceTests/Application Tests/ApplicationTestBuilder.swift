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
        
        func registerRemoteNotifications(_ deviceToken: Data = Data()) {
            application.registerRemoteNotifications(deviceToken: deviceToken)
        }
        
        func login(registrationNumber: Int = 0, username: String = "", password: String = "") {
            let arguments = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            application.login(arguments)
        }
        
    }
    
    private let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var capturingLoginCredentialsStore = CapturingLoginCredentialStore()
    private var stubClock = StubClock()
    private var loginAPI = CapturingLoginAPI()
    
    func with(_ currentDate: Date) -> ApplicationTestBuilder {
        stubClock = StubClock(currentDate: currentDate)
        return self
    }
    
    func with(_ persistedCredential: LoginCredential?) -> ApplicationTestBuilder {
        capturingLoginCredentialsStore = CapturingLoginCredentialStore(persistedCredential: persistedCredential)
        return self
    }
    
    func with(_ loginAPI: CapturingLoginAPI) -> ApplicationTestBuilder {
        self.loginAPI = loginAPI
        return self
    }
    
    func build() -> Context {
        let app = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration,
                                         clock: stubClock,
                                         loginCredentialStore: capturingLoginCredentialsStore,
                                         loginAPI: loginAPI)
        return Context(application: app,
                       capturingTokenRegistration: capturingTokenRegistration,
                       capturingLoginCredentialsStore: capturingLoginCredentialsStore,
                       loginAPI: loginAPI)
    }
    
}
