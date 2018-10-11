//
//  CapturingLoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingLoginAPI: LoginAPI {

    private(set) var capturedLoginRequest: LoginRequest?
    private var handler: ((LoginResponse?) -> Void)?
    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        capturedLoginRequest = request
        handler = completionHandler
    }

    func simulateResponse(_ response: LoginResponse) {
        handler?(response)
    }

    func simulateFailure() {
        handler?(nil)
    }

}
