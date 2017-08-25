//
//  StubAuthService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubAuthService: AuthService {
    
    private let authState: AuthState
    
    init(authState: AuthState) {
        self.authState = authState
    }
    
    private var observers = [AuthStateObserver]()
    func add(observer: AuthStateObserver) {
        observers.append(observer)
    }
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        completionHandler(authState)
    }
    
    func notifyObserversUserDidLogin() {
        observers.forEach { $0.userDidLogin() }
    }
    
}
