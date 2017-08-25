//
//  EurofurenceAuthServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol EurofurenceApplicationProtocol {
    
    func determineAuthorization()
    
}

class EurofurenceAuthService: AuthService {
    
    private let app: EurofurenceApplicationProtocol
    
    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }
    
    func add(observer: AuthStateObserver) {
        
    }
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        app.determineAuthorization()
    }
    
}

class CapturingEurofurenceApplication: EurofurenceApplicationProtocol {
    
    private(set) var wasRequestedForAuthState = false
    func determineAuthorization() {
        wasRequestedForAuthState = true
    }
    
}

class EurofurenceAuthServiceTests: XCTestCase {
    
    func testDeterminingAuthStateRequestsAuthStateFromApplication() {
        let app = CapturingEurofurenceApplication()
        let service = EurofurenceAuthService(app: app)
        service.determineAuthState { _ in }
        
        XCTAssertTrue(app.wasRequestedForAuthState)
    }
    
}
