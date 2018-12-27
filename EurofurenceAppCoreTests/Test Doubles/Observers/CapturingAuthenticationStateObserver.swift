//
//  CapturingAuthenticationStateObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingAuthenticationStateObserver: AuthenticationStateObserver {

    private(set) var capturedLoggedInUser: User?
    func userDidLogin(_ user: User) {
        capturedLoggedInUser = user
    }

    var loggedOut = false
    func userDidLogout() {
        loggedOut = true
    }

}
