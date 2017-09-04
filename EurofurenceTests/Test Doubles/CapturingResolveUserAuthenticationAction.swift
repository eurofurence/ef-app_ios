//
//  CapturingResolveUserAuthenticationAction.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingResolveUserAuthenticationAction: ResolveUserAuthenticationAction {
    
    private(set) var wasRan = false
    private var completionHandler: ((Bool) -> Void)?
    func run(completionHandler: @escaping (Bool) -> Void) {
        wasRan = true
        self.completionHandler = completionHandler
    }
    
    func resolveUser() {
        completionHandler?(true)
    }
    
    func failToResolveUser() {
        completionHandler?(false)
    }
    
}
