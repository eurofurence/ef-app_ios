//
//  NewsPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol AuthService {
    
    func determineAuthState()
    
}

class CapturingAuthService: AuthService {
    
    private(set) var wasRequestedToDetermineAuthState = false
    func determineAuthState() {
        wasRequestedToDetermineAuthState = true
    }
    
}

struct NewsPresenter {
    
    init(authService: AuthService) {
        authService.determineAuthState()
    }
    
}

class NewsPresenterTests: XCTestCase {
    
    func testWhenLaunchedTheAuthServiceIsRequestedTheLoginState() {
        let authService = CapturingAuthService()
        _ = NewsPresenter(authService: authService)
        
        XCTAssertTrue(authService.wasRequestedToDetermineAuthState)
    }
    
}
