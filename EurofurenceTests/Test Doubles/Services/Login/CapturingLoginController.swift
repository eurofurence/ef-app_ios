//
//  CapturingLoginController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingLoginController: LoginController {
    
    private(set) var observers = [LoginStateObserver]()
    func add(_ observer: LoginStateObserver) {
        observers.append(observer)
    }
    
    func notifyUserLoggedIn(_ authenticationToken: String = "", expires: Date = .distantFuture) {
        let credential = LoginCredential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: authenticationToken,
                                         tokenExpiryDate: expires)
        observers.forEach({ $0.userDidLogin(credential: credential) })
    }
    
    func notifyUserLoggedOut() {
        observers.forEach({ $0.userDidLogout() })
    }
    
}
