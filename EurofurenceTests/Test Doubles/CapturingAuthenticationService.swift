//
//  CapturingAuthenticationService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingAuthenticationService: AuthenticationService {
    
    func add(observer: AuthenticationStateObserver) {
        
    }
    
    private(set) var authStateDeterminedCount = 0
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        authStateDeterminedCount += 1
    }
    
    private(set) var capturedRequest: LoginServiceRequest?
    fileprivate var capturedCompletionHandler: ((LoginServiceResult) -> Void)?
    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void) {
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
