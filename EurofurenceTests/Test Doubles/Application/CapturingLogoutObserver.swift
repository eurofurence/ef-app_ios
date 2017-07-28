//
//  CapturingLogoutObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingLogoutObserver: LogoutObserver {
    
    private(set) var didFailToLogout = false
    func logoutFailed() {
        didFailToLogout = true
    }
    
}
