//
//  WhenRequestingPrivateMessages.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenRequestingPrivateMessages: XCTestCase {
    
    func testBeingLoggedOutShouldProvideEmptyMessages() {
        let context = ApplicationTestBuilder().build()
        let capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.add(capturingMessagesObserver)
        context.application.fetchPrivateMessages()
        
        XCTAssertEqual(0, capturingMessagesObserver.capturedMessages?.count)
    }
    
    func testBeingLoggedOutShouldNotProvideEmptyMessagesUntilAskingToLoadThem() {
        let context = ApplicationTestBuilder().build()
        let capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.application.add(capturingMessagesObserver)
        
        XCTAssertNil(capturingMessagesObserver.capturedMessages)
    }
    
    func testBeingLoggedInShouldRequestPrivateMessagesFromAPI() {
        let credential = LoginCredential(username: "",
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        context.application.fetchPrivateMessages()
        
        XCTAssertTrue(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
    func testBeingLoggedOutShouldNotRequestPrivateMessagesFromAPI() {
        let context = ApplicationTestBuilder().build()
        context.application.fetchPrivateMessages()
        
        XCTAssertFalse(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
}
