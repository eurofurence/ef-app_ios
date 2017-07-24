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
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.application.fetchPrivateMessages()
        
        XCTAssertTrue(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
    func testBeingLoggedOutShouldNotRequestPrivateMessagesFromAPI() {
        let context = ApplicationTestBuilder().build()
        context.application.fetchPrivateMessages()
        
        XCTAssertFalse(context.privateMessagesAPI.wasToldToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithErrorShouldTellObserversFailedToLoadPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(observer)
        context.application.fetchPrivateMessages()
        context.privateMessagesAPI.simulateUnsuccessfulResponse()
        
        XCTAssertTrue(observer.wasToldFailedToLoadPrivateMessages)
    }
    
    func testReceievingAPIResponseWithSuccessShouldNotTellObserversFailedToLoadPrivateMessages() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.application.add(observer)
        context.application.fetchPrivateMessages()
        context.privateMessagesAPI.simulateSuccessfulResponse()
        
        XCTAssertFalse(observer.wasToldFailedToLoadPrivateMessages)
    }
    
}
