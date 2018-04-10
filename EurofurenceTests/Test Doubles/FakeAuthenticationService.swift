//
//  FakeAuthenticationService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class FakeAuthenticationService: AuthenticationService {
    
    private let authState: AuthState
    
    init(authState: AuthState) {
        self.authState = authState
    }
    
    fileprivate var observers = [AuthenticationStateObserver]()
    func add(observer: AuthenticationStateObserver) {
        observers.append(observer)
    }
    
    private(set) var authStateDeterminedCount = 0
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        completionHandler(authState)
        authStateDeterminedCount += 1
    }
    
    private(set) var capturedRequest: LoginServiceRequest?
    fileprivate var capturedCompletionHandler: ((LoginServiceResult) -> Void)?
    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void) {
        capturedRequest = request
        capturedCompletionHandler = completionHandler
    }
    
}

extension FakeAuthenticationService {
    
    func fulfillRequest() {
        capturedCompletionHandler?(.success)
    }
    
    func failRequest() {
        capturedCompletionHandler?(.failure)
    }
    
    func notifyObserversUserDidLogin(_ user: User = User(registrationNumber: 42, username: "")) {
        observers.forEach { $0.userDidLogin(user) }
    }
    
    func notifyObserversUserDidLogout() {
        observers.forEach { $0.userDidLogout() }
    }
    
}
