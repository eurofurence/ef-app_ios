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
        var application: EurofurenceApplicationProtocol
        
        var capturingTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var capturingCredentialStore: CapturingCredentialStore
        var loginAPI: CapturingLoginAPI
        var privateMessagesAPI: CapturingPrivateMessagesAPI
        var syncAPI: CapturingSyncAPI
        var dataStore: CapturingEurofurenceDataStore
        var dateDistanceCalculator: StubDateDistanceCalculator
        var conventionStartDateRepository: StubConventionStartDateRepository
        var significantTimeChangeEventSource: FakeSignificantTimeChangeEventSource
        
        var authenticationToken: String? {
            return capturingCredentialStore.persistedCredential?.authenticationToken
        }
        
        
        func registerForRemoteNotifications(_ deviceToken: Data = Data()) {
            application.storeRemoteNotificationsToken(deviceToken)
        }
        
        func login(registrationNumber: Int = 0,
                   username: String = "",
                   password: String = "",
                   completionHandler: @escaping (LoginResult) -> Void = { _ in }) {
            let arguments = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            application.login(arguments, completionHandler: completionHandler)
        }
        
        func loginSuccessfully() {
            login()
            loginAPI.simulateResponse(LoginResponse(userIdentifier: .random, username: .random, token: .random, tokenValidUntil: Date(timeIntervalSinceNow: 1)))
        }
        
        func refreshLocalStore(completionHandler: ((Error?) -> Void)? = nil) {
            _ = application.refreshLocalStore { (error) in
                completionHandler?(error)
            }
        }
        
    }
    
    private let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var capturingCredentialStore = CapturingCredentialStore()
    private var stubClock = StubClock()
    private let loginAPI = CapturingLoginAPI()
    private let privateMessagesAPI = CapturingPrivateMessagesAPI()
    private var pushPermissionsRequester: PushPermissionsRequester = CapturingPushPermissionsRequester()
    private var pushPermissionsStateProviding: PushPermissionsStateProviding = CapturingPushPermissionsStateProviding()
    private var dataStore = CapturingEurofurenceDataStore()
    private var userPreferences: UserPreferences = StubUserPreferences()
    private let syncAPI = CapturingSyncAPI()
    
    func with(_ currentDate: Date) -> ApplicationTestBuilder {
        stubClock = StubClock(currentDate: currentDate)
        return self
    }
    
    func with(_ persistedCredential: Credential?) -> ApplicationTestBuilder {
        capturingCredentialStore = CapturingCredentialStore(persistedCredential: persistedCredential)
        return self
    }
    
    func with(_ pushPermissionsRequester: PushPermissionsRequester) -> ApplicationTestBuilder {
        self.pushPermissionsRequester = pushPermissionsRequester
        return self
    }
    
    func with(_ pushPermissionsStateProviding: PushPermissionsStateProviding) -> ApplicationTestBuilder {
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
        return self
    }
    
    @discardableResult
    func with(_ dataStore: CapturingEurofurenceDataStore) -> ApplicationTestBuilder {
        self.dataStore = dataStore
        return self
    }
    
    @discardableResult
    func with(_ userPreferences: UserPreferences) -> ApplicationTestBuilder {
        self.userPreferences = userPreferences
        return self
    }
    
    func loggedInWithValidCredential() -> ApplicationTestBuilder {
        let credential = Credential(username: "User",
                                    registrationNumber: 42,
                                    authenticationToken: "Token",
                                    tokenExpiryDate: .distantFuture)
        return with(credential)
    }
    
    @discardableResult
    func build() -> Context {
        let dateDistanceCalculator = StubDateDistanceCalculator()
        let conventionStartDateRepository = StubConventionStartDateRepository()
        let significantTimeChangeEventSource = FakeSignificantTimeChangeEventSource()
        let app = EurofurenceApplicationBuilder()
            .with(stubClock).with(capturingCredentialStore)
            .with(dataStore)
            .with(loginAPI)
            .with(privateMessagesAPI)
            .with(pushPermissionsRequester)
            .with(pushPermissionsStateProviding)
            .with(capturingTokenRegistration)
            .with(userPreferences)
            .with(syncAPI)
            .with(dateDistanceCalculator)
            .with(conventionStartDateRepository)
            .with(significantTimeChangeEventSource)
            .build()
        
        return Context(application: app,
                       capturingTokenRegistration: capturingTokenRegistration,
                       capturingCredentialStore: capturingCredentialStore,
                       loginAPI: loginAPI,
                       privateMessagesAPI: privateMessagesAPI,
                       syncAPI: syncAPI,
                       dataStore: dataStore,
                       dateDistanceCalculator: dateDistanceCalculator,
                       conventionStartDateRepository: conventionStartDateRepository,
                       significantTimeChangeEventSource: significantTimeChangeEventSource)
    }
    
}
