//
//  CapturingLoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingLoginAPI: LoginAPI {
    
    private(set) var capturedLoginRequest: LoginRequest?
    private var handler: LoginResponseHandler?
    func performLogin(request: LoginRequest) {
        capturedLoginRequest = request
        handler = request.completionHandler
    }
    
    func simulateResponse(_ response: LoginResponse) {
        handler?(.success(response))
    }
    
    func simulateFailure() {
        handler?(.failure)
    }
    
}
