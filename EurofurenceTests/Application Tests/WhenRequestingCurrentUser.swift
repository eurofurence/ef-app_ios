//
//  WhenRequestingCurrentUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenRequestingCurrentUser: XCTestCase {
    
    func testBeingLoggedInShouldProvideUserWithLoginCredentials() {
        let expectedUser = User(registrationNumber: 42, username: "Username")
        let credential = LoginCredential(username: expectedUser.username,
                                         registrationNumber: expectedUser.registrationNumber,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        var capturedUser: User?
        context.application.retrieveCurrentUser { capturedUser = $0 }
        
        XCTAssertEqual(expectedUser, capturedUser)
    }
    
    func testNotBeingLoggedInShouldCallCompletionHandler() {
        let context = ApplicationTestBuilder().build()
        var invokedHandler = false
        context.application.retrieveCurrentUser { _ in invokedHandler = true }
        
        XCTAssertTrue(invokedHandler)
    }
    
    func testNotBeingLoggedInShouldCallCompletionHandlerWithNilUser() {
        let context = ApplicationTestBuilder().build()
        var capturedUser: User?
        context.application.retrieveCurrentUser { capturedUser = $0 }
        
        XCTAssertNil(capturedUser)
    }
    
}
