//
//  CapturingAuthenticationStateObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingAuthenticationStateObserver: AuthenticationStateObserver {
    
    private(set) var didLogIn = false
    func loggedIn() {
        didLogIn = true
    }
    
}
