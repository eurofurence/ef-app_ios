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
    
    func retrieveCurrentUser()
    
}

class EurofurenceAuthService: AuthService {
    
    private let app: EurofurenceApplicationProtocol
    
    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }
    
    func add(observer: AuthStateObserver) {
        
    }
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        app.retrieveCurrentUser()
    }
    
}

class CapturingEurofurenceApplication: EurofurenceApplicationProtocol {
    
    private(set) var wasRequestedForCurrentUser = false
    func retrieveCurrentUser() {
        wasRequestedForCurrentUser = true
    }
    
}

class EurofurenceAuthServiceTests: XCTestCase {
    
    func testDeterminingAuthStateRequestsUserFromApplication() {
        let app = CapturingEurofurenceApplication()
        let service = EurofurenceAuthService(app: app)
        service.determineAuthState { _ in }
        
        XCTAssertTrue(app.wasRequestedForCurrentUser)
    }
    
}
