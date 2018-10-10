//
//  CapturingLogoutObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore

class CapturingLogoutObserver {
    
    private(set) var didLogout = false
    private(set) var didFailToLogout = false
    func completionHandler(_ result: LogoutResult) {
        switch result {
        case .success:
            didLogout = true
            
        case .failure:
            didFailToLogout = true
        }
    }
    
}
