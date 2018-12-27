//
//  CapturingLoginModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel

class CapturingLoginModuleDelegate: LoginModuleDelegate {

    private(set) var loginCancelled = false
    func loginModuleDidCancelLogin() {
        loginCancelled = true
    }

    private(set) var loginFinishedSuccessfully = false
    func loginModuleDidLoginSuccessfully() {
        loginFinishedSuccessfully = true
    }

}
