//
//  CapturingAuthenticationService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingAuthenticationService: StubAuthenticationService {
    
    private(set) var authStateDeterminedCount = 0
    override func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        super.determineAuthState(completionHandler: completionHandler)
        authStateDeterminedCount += 1
    }
    
    private(set) var capturedRequest: LoginServiceRequest?
    fileprivate var capturedCompletionHandler: ((LoginServiceResult) -> Void)?
    override  func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void) {
        super.perform(request, completionHandler: completionHandler)
        capturedRequest = request
        capturedCompletionHandler = completionHandler
    }
    
}

extension CapturingAuthenticationService {
    
    func fulfillRequest() {
        capturedCompletionHandler?(.success)
    }
    
    func failRequest() {
        capturedCompletionHandler?(.failure)
    }
    
}
