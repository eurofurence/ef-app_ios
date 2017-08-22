//
//  CapturingLoginObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingLoginObserver {
    
    private(set) var notifiedLoginSucceeded = false
    private(set) var notifiedLoginFailed = false
    func completionHandler(_ result: LoginResult) {
        switch result {
        case .success:
            self.notifiedLoginSucceeded = true
        case .failure:
            self.notifiedLoginFailed = true
        }
    }
    
}
