//
//  StubAuthenticationService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubAuthenticationService: AuthenticationService {
    
    private let authState: AuthState
    
    init(authState: AuthState) {
        self.authState = authState
    }
    
    private var observers = [AuthenticationStateObserver]()
    func add(observer: AuthenticationStateObserver) {
        observers.append(observer)
    }
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        completionHandler(authState)
    }
    
    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void) {
        
    }
    
    func notifyObserversUserDidLogin(_ user: User = User(registrationNumber: 42, username: "")) {
        observers.forEach { $0.userDidLogin(user) }
    }
    
    func notifyObserversUserDidLogout() {
        observers.forEach { $0.userDidLogout() }
    }
    
}
