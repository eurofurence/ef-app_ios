//
//  CapturingLoginObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingLoginObserver: LoginObserver {
    
    private(set) var notifiedLoginSucceeded = false
    func userDidLogin() {
        notifiedLoginSucceeded = true
    }
    
    private(set) var notifiedLoginFailed = false
    func userDidFailToLogIn() {
        notifiedLoginFailed = true
    }
    
}
