//
//  FakeAuthenticationService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class FakeAuthenticationService: AuthenticationService {
    
    enum AuthState {
        case loggedIn(User)
        case loggedOut
    }
    
    fileprivate(set) var authState: AuthState
    
    class func loggedInService(_ user: User = .random) -> FakeAuthenticationService {
        return FakeAuthenticationService(authState: .loggedIn(user))
    }
    
    class func loggedOutService() -> FakeAuthenticationService {
        return FakeAuthenticationService(authState: .loggedOut)
    }
    
    init(authState: AuthState) {
        self.authState = authState
    }
    
    fileprivate var observers = [AuthenticationStateObserver]()
    func add(_ observer: AuthenticationStateObserver) {
        observers.append(observer)
        
        switch authState {
        case .loggedIn(let user):
            observer.userDidLogin(user)
            
        case .loggedOut:
            observer.userDidLogout()
        }
    }
    
    private(set) var authStateDeterminedCount = 0
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        completionHandler(authState)
        authStateDeterminedCount += 1
    }
    
    private(set) var capturedRequest: LoginArguments?
    fileprivate var capturedCompletionHandler: ((LoginResult) -> Void)?
    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        capturedRequest = arguments
        capturedCompletionHandler = completionHandler
    }
    
    private(set) var wasToldToLogout = false
    private(set) var capturedLogoutHandler: ((LogoutResult) -> Void)?
    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        wasToldToLogout = true
        capturedLogoutHandler = completionHandler
    }
    
}

extension FakeAuthenticationService {
    
    func fulfillRequest() {
        capturedCompletionHandler?(.success(.random))
    }
    
    func failRequest() {
        capturedCompletionHandler?(.failure)
    }
    
    func notifyObserversUserDidLogin(_ user: User = User(registrationNumber: 42, username: "")) {
        authState = .loggedIn(user)
        observers.forEach { $0.userDidLogin(user) }
    }
    
    func notifyObserversUserDidLogout() {
        authState = .loggedOut
        observers.forEach { $0.userDidLogout() }
    }
    
}
