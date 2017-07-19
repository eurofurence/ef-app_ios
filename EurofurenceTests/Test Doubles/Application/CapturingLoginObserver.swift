//
//  CapturingUserAuthenticationObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingUserAuthenticationObserver: UserAuthenticationObserver {
    
    private(set) var notifiedLoginSucceeded = false
    func userAuthenticationAuthorized() {
        notifiedLoginSucceeded = true
    }
    
    private(set) var notifiedLoginFailed = false
    func userAuthenticationUnauthorized() {
        notifiedLoginFailed = true
    }
    
}
