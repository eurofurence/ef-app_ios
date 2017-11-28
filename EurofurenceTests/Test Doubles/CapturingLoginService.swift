//
//  CapturingLoginService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingLoginService: LoginService {
    
    private(set) var capturedRequest: LoginServiceRequest?
    private var capturedCompletionHandler: ((LoginServiceResult) -> Void)?
    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void) {
        capturedRequest = request
        capturedCompletionHandler = completionHandler
    }
    
    func fulfillRequest() {
        capturedCompletionHandler?(.success)
    }
    
    func failRequest() {
        capturedCompletionHandler?(.failure)
    }
    
}
